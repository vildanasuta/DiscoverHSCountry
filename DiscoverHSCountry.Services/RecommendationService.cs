using AutoMapper;
using AutoMapper.Internal;
using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Factorization;
using MathNet.Numerics.LinearAlgebra.Double;
using Microsoft.EntityFrameworkCore;
using System.Linq.Dynamic.Core;

namespace DiscoverHSCountry.Services
{
    public class RecommendationService : BaseCRUDService<Model.Recommendation, Database.Recommendation, RecommendationSearchObject, RecommendationCreateRequest, RecommendationUpdateRequest>, IRecommendationService
    {
        private readonly DiscoverHSCountryContext _context;

        public RecommendationService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }


        public async Task<List<Database.Recommendation>> GenerateRecommendationsAsync(int touristId)
        {
            List<Database.Recommendation> recommendations = await GenerateRecommendationsBasedOnSimilarityAsync(touristId);
            recommendations.AddRange(await GenerateMatrixFactorizationRecommendationsAsync(touristId));

            var visitedLocations = await GetUserVisitedLocationsAsync(touristId);

            var uniqueLocationIds = new HashSet<int>();

            foreach (var recommendation in recommendations)
            {
                var locationExists = await _context.Locations
                    .AnyAsync(location => location.LocationId == recommendation.LocationId);

                if (locationExists && !uniqueLocationIds.Contains(recommendation.LocationId) && !visitedLocations.Contains(recommendation.LocationId))
                {
                    uniqueLocationIds.Add(recommendation.LocationId); 
                    _context.Recommendation.Add(recommendation); 
                }
            }

            await _context.SaveChangesAsync();

            return recommendations;
        }


        private async Task<List<Database.Recommendation>> GenerateRecommendationsBasedOnSimilarityAsync(int targetTouristId)
        {
            List<Database.Recommendation> recommendations = new List<Database.Recommendation>();

            var visitedLocations = await GetUserVisitedLocationsAsync(targetTouristId);
            var clickedLocations = await GetUserClickedLocationsAsync(targetTouristId);
            var highlyRatedLocations = await GetUserHighlyRatedLocationsAsync(targetTouristId);

            List<int> similarUsers = await FindSimilarUsersAsync(targetTouristId, visitedLocations, clickedLocations, highlyRatedLocations);

            

                foreach (var userId in similarUsers)
                {


                    var visitedLocationsForUser = await GetUserClickedLocationsAsync(userId);

                    var locationVisitsForUser = await GetUserClickedLocationsAsync(userId);

                    var highlyRatedLocationsForUser = await GetUserHighlyRatedLocationsAsync(userId);

                    var visitedLocationsEnumerable = visitedLocationsForUser.Select(locationId => (int?)locationId);
                    var locationVisitsEnumerable = locationVisitsForUser.Select(locationId => (int?)locationId);
                    var locationsRatedGoodEnumerable = highlyRatedLocationsForUser.Select(locationId => (int?)locationId);

                    var potentialRecommendations = visitedLocationsEnumerable
                        .Concat(locationVisitsEnumerable)
                        .Concat(locationsRatedGoodEnumerable)
                        .Distinct()
                        .ToList();

                    foreach (var locationId in potentialRecommendations)
                    {
                        recommendations.Add(new Database.Recommendation
                        {
                            TouristId = targetTouristId,
                            LocationId = (int)locationId
                        });
                    }
                }
            


            return recommendations;
        }

        private async Task<List<int>> FindSimilarUsersAsync(int targetTouristId, List<int?> visitedLocations, List<int?> clickedLocations, List<int?> highlyRatedLocations)
        {
            Dictionary<int, double> userSimilarityScores = new Dictionary<int, double>();
            List<Database.Tourist> allUsers;
            
                allUsers = await _context.Tourists.ToListAsync();
            

            foreach (var user in allUsers)
            {
                if (user.TouristId == targetTouristId)
                {
                    // Skip the user we are finding recommendations for
                    continue;
                }

                double similarityScore = await CalculateUserSimilarityAsync(user, visitedLocations, clickedLocations, highlyRatedLocations, targetTouristId);

                userSimilarityScores[user.TouristId] = similarityScore;
            }

            var similarUsers = userSimilarityScores.OrderByDescending(x => x.Value).Select(x => x.Key).ToList();
            return similarUsers;
        }

        private async Task<double> CalculateUserSimilarityAsync(Database.Tourist user, List<int?> visitedLocations, List<int?> clickedLocations, List<int?> highlyRatedLocations, int targetTouristId)
        {

            double cosineSimilarity = await CalculateCosineSimilarityAsync(user, visitedLocations, clickedLocations, highlyRatedLocations, targetTouristId);

            return cosineSimilarity;
        }

        private async Task<double> CalculateCosineSimilarityAsync(Database.Tourist user, List<int?> visitedLocations, List<int?> clickedLocations, List<int?> highlyRatedLocations, int targetTouristId)
        {
            var targetUser = await _context.Tourists.Where(tourist => tourist.TouristId == targetTouristId).FirstOrDefaultAsync();
            
            double dotProduct = await CalculateDotProductAsync(user, visitedLocations, clickedLocations, highlyRatedLocations);
            double magnitudeUser =  CalculateVectorMagnitude(user, visitedLocations, clickedLocations, highlyRatedLocations);
            double magnitudeTarget = CalculateVectorMagnitude(targetUser, visitedLocations, clickedLocations, highlyRatedLocations);

            if (magnitudeUser == 0 || magnitudeTarget == 0)
            {
                return 0; // To avoid division by zero
            }

            return dotProduct / (magnitudeUser * magnitudeTarget);
        }

        private async Task<double> CalculateDotProductAsync(Database.Tourist user, List<int?> visitedLocations, List<int?> clickedLocations, List<int?> highlyRatedLocations)
        {
            double dotProduct = 0.0;

            
                // Fetch the user's data from the database
                var visitedLocationsForUser = await _context.VisitedLocations
                .Where(visitedLocation => visitedLocation.TouristId == user.UserId)
                .Select(visitedLocation => (int?)visitedLocation.LocationId)
                .ToListAsync();

                var locationVisitsForUser = await _context.LocationVisits
                    .Where(locationVisits => locationVisits.TouristId == user.UserId)
                    .Where(locationVisits => locationVisits.NumberOfVisits > 0)
                    .Select(locationVisits => (int?)locationVisits.LocationId)
                    .ToListAsync();

                var highlyRatedLocationsForUser = await _context.Reviews
                    .Where(review => review.TouristId == user.UserId && review.Rate > 4.0)
                    .Select(review => (int?)review.LocationId)
                    .ToListAsync();

                int vectorLength = Math.Max(Math.Max(visitedLocations.Count, locationVisitsForUser.Count), highlyRatedLocationsForUser.Count);


                for (int i = 0; i < vectorLength; i++)
                {
                    double userVisited = i < visitedLocationsForUser.Count ? (double)visitedLocationsForUser[i] : 0.0;
                    double userClicked = i < locationVisitsForUser.Count ? (double)locationVisitsForUser[i] : 0.0;
                    double userHighlyRated = i < highlyRatedLocationsForUser.Count ? (double)highlyRatedLocationsForUser[i] : 0.0;

                    double targetVisited = i < visitedLocations.Count ? (double)visitedLocations[i] : 0.0;
                    double targetClicked = i < clickedLocations.Count ? (double)clickedLocations[i] : 0.0;
                    double targetHighlyRated = i < highlyRatedLocations.Count ? (double)highlyRatedLocations[i] : 0.0;

                    double elementProduct = userVisited * targetVisited + userClicked * targetClicked + userHighlyRated * targetHighlyRated;

                    dotProduct += elementProduct;
                }
            
            return dotProduct;
        }


        private double CalculateVectorMagnitude(Database.Tourist user, List<int?> visitedLocations, List<int?> clickedLocations, List<int?> highlyRatedLocations)
        {
            double magnitude = 0.0;
            int vectorLength = Math.Max(Math.Max(visitedLocations.Count, clickedLocations.Count), highlyRatedLocations.Count);

            for (int i = 0; i < vectorLength; i++)
            {
                double userVisited = i < visitedLocations.Count ? (double)visitedLocations[i] : 0.0;
                double userClicked = i < clickedLocations.Count ? (double)clickedLocations[i] : 0.0;
                double userHighlyRated = i < highlyRatedLocations.Count ? (double)highlyRatedLocations[i] : 0.0;

                magnitude += userVisited * userVisited + userClicked * userClicked + userHighlyRated * userHighlyRated;
            }

            magnitude = Math.Sqrt(magnitude);

            return magnitude;
        }



        private int maxUserId = 2;
        private int maxLocationId = 1019;

        private async Task<int[,]> CreateUserItemMatrixAsync()
        {
            int[,] userItemMatrix = new int[maxUserId + 1, maxLocationId + 1];
            
                foreach (var user in _context.Tourists)
                {
                    int userId = user.TouristId;
                    List<int?> visitedLocations = await GetUserVisitedLocationsAsync(userId);
                    List<int?> clickedLocations = await GetUserClickedLocationsAsync(userId);
                    List<int?> highlyRatedLocations = await GetUserHighlyRatedLocationsAsync(userId);

                    foreach (var locationId in visitedLocations)
                    {
                        userItemMatrix[userId, locationId.Value] = 1;
                    }

                    foreach (var locationId in clickedLocations)
                    {
                        userItemMatrix[userId, locationId.Value] = 1;
                    }

                    foreach (var locationId in highlyRatedLocations)
                    {
                        userItemMatrix[userId, locationId.Value] = 1;
                    }
                }
            

            return userItemMatrix;
        }

        private async Task<List<int?>> GetUserHighlyRatedLocationsAsync(int userId)
        {
            List<int?> highlyRatedLocations;
            
                highlyRatedLocations = await _context.Reviews
               .Where(review => review.TouristId == userId && review.Rate > 4.0)
               .Select(review => (int?)review.LocationId)
               .ToListAsync();
            
            return highlyRatedLocations;
        }

        private async Task<List<int?>> GetUserClickedLocationsAsync(int userId)
        {
            List<int?> clickedLocations;
            
                clickedLocations = await _context.LocationVisits
                .Where(locationVisits => locationVisits.TouristId == userId && locationVisits.NumberOfVisits > 0)
                .Select(locationVisits => (int?)locationVisits.LocationId)
                .ToListAsync();
            
            return clickedLocations;
        }

        private async Task<List<int?>> GetUserVisitedLocationsAsync(int userId)
        {
            List<int?> visitedLocations;
            
                visitedLocations = await _context.VisitedLocations
                    .Where(visitedLocation => visitedLocation.TouristId == userId)
                    .Select(visitedLocation => (int?)visitedLocation.LocationId)
                    .ToListAsync();

            
            return visitedLocations;

        }


        private async Task<List<Database.Recommendation>> GenerateMatrixFactorizationRecommendationsAsync(int targetUserId)
        {
            var (userPreferences, itemFeatures) = await PerformSVDAsync(targetUserId);

            int N = 10;
            List<int> recommendedItems = GetTopNRecommendations(userPreferences, itemFeatures, N);

            List<Database.Recommendation> recommendations = new List<Database.Recommendation>();
            foreach (var itemId in recommendedItems)
            {
                recommendations.Add(new Database.Recommendation
                {
                    TouristId = targetUserId,
                    LocationId = itemId
                });
            }

            return recommendations;
        }
        private async Task<(double[], double[,])> PerformSVDAsync(int targetUserId)
        {
            int numRows = maxUserId + 1;
            int numCols = maxLocationId + 1;

            var doubleUserItemMatrix = new double[numRows, numCols];

            int[,] intUserItemMatrix = await CreateUserItemMatrixAsync();

            for (int i = 0; i < numRows; i++)
            {
                for (int j = 0; j < numCols; j++)
                {
                    doubleUserItemMatrix[i, j] = (double)intUserItemMatrix[i, j];
                }
            }

            Matrix<double> userItemMatrix = DenseMatrix.OfArray(doubleUserItemMatrix);

            Svd<double> svd = userItemMatrix.Svd(true);

            Matrix<double> userPreferences = svd.U;
            Vector<double> singularValues = svd.S;
            Matrix<double> itemFeatures = svd.VT;

            double[] userPreferencesArray = userPreferences.ToColumnMajorArray();
            double[,] itemFeaturesArray = ConvertTo2DArray(itemFeatures.ToColumnMajorArray(), itemFeatures.RowCount, itemFeatures.ColumnCount);

            return (userPreferencesArray, itemFeaturesArray);
        }

        private double[,] ConvertTo2DArray(double[] sourceArray, int numRows, int numCols)
        {
            double[,] resultArray = new double[numRows, numCols];
            int index = 0;

            for (int i = 0; i < numRows; i++)
            {
                for (int j = 0; j < numCols; j++)
                {
                    resultArray[i, j] = sourceArray[index];
                    index++;
                }
            }

            return resultArray;
        }


        private List<int> GetTopNRecommendations(double[] userPreferences, double[,] itemFeatures, int N)
        {
            List<(int ItemId, double Score)> recommendationScores = new List<(int, double)>();

            int numItems = itemFeatures.GetLength(0);

            for (int itemId = 0; itemId < numItems; itemId++)
            {
                double score = CalculateRecommendationScore(userPreferences, itemFeatures, itemId);
                recommendationScores.Add((itemId, score));
            }

            var topNItems = recommendationScores
                .OrderByDescending(x => x.Score)
                .Select(x => x.ItemId)
                .Take(N)
                .ToList();

            return topNItems;
        }

        private double CalculateRecommendationScore(double[] userPreferences, double[,] itemFeatures, int itemId)
        {
            int numUsers = userPreferences.Length;
            double score = 0.0;

            for (int userIndex = 0; userIndex < numUsers; userIndex++)
            {
                score += userPreferences[userIndex] * itemFeatures[itemId, userIndex];
            }

            return score;
        }




    }
}
