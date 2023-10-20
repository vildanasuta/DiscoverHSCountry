using DiscoverHSCountry.Services;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using DiscoverHSCountry.Model;
using System.Text.Json.Serialization;
using MathNet.Numerics;
using RabbitMQ.Client;
using System.Threading.Channels;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<ITouristService, TouristService>();
builder.Services.AddTransient<IAdministratorService, AdministratorService>();
builder.Services.AddTransient<ITouristAttractionOwnerService, TouristAttractionOwnerService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<IEventService, EventService>();
builder.Services.AddTransient<IEventLocationService, EventLocationService>();
builder.Services.AddTransient<IEventCategoryService, EventCategoryService>();
builder.Services.AddTransient<IHistoricalEventService, HistoricalEventService>();
builder.Services.AddTransient<ILocationService, LocationService>();
builder.Services.AddTransient<ILocationTouristAttractionOwnerService, LocationTouristAttractionOwnerService>();
builder.Services.AddTransient<ILocationCategoryService, LocationCategoryService>();
builder.Services.AddTransient<ILocationImageService, LocationImageService>();
builder.Services.AddTransient<ILocationSubcategoryService, LocationSubcategoryService>();
builder.Services.AddTransient<IReservationService, DiscoverHSCountry.Services.ReservationService>();
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<IServiceService, ServiceService>();
builder.Services.AddTransient<ITechnicalIssueOwnerService, TechnicalIssueOwnerService>();
builder.Services.AddTransient<ITechnicalIssueTouristService, TechnicalIssueTouristService>();
builder.Services.AddTransient<IVisitedLocationService, VisitedLocationService>();
builder.Services.AddTransient<IVisitedLocationImageService, VisitedLocationImageService>();
builder.Services.AddTransient<IPublicCityServiceService, PublicCityServiceService>();
builder.Services.AddTransient<IReservationServiceService, ReservationServiceService>();
builder.Services.AddTransient<ILocationVisitsService, LocationVisitsService>();
builder.Services.AddTransient<IRecommendationService, RecommendationService>();


//for docker:
var factory = new ConnectionFactory
{
    HostName = "host.docker.internal",
    Port = 5672,
    UserName = "guest",
    Password = "guest",
};
/* locally:
var factory = new ConnectionFactory
{
    HostName = "localhost",
    Port = 5672,
    UserName = "guest",
    Password = "guest",
};*/
var connection = factory.CreateConnection();
var channel = connection.CreateModel();

builder.Services.AddTransient<IModel>(_ => (IModel)channel);

// Register the EmailService and start listening for messages
builder.Services.AddTransient<RabbitMQEmailProducer>();
builder.Services.AddTransient<EmailService>();

builder.Services.AddControllers()
            .AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.Preserve;
            });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<DiscoverHSCountryContext>(options=>
options.UseSqlServer(connectionString));
builder.Services.AddAutoMapper(typeof(IUserService));
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();


/*using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<DiscoverHSCountryContext>();
    dataContext.Database.Migrate();
}*/
app.Run();
