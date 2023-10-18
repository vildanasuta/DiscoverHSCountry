using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IRecommendationService : ICRUDService<Model.Recommendation, Model.SearchObjects.RecommendationSearchObject, Model.Requests.RecommendationCreateRequest, Model.Requests.RecommendationUpdateRequest>
    {
        public Task<List<Database.Recommendation>> GenerateRecommendationsAsync(int touristId);
    }
}
