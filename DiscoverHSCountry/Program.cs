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
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Util;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.Filters;

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


builder.Services.AddAuthentication(
    JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options => {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey=true,
            IssuerSigningKey=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration.GetSection("AppSettings:Token").Value)),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });


//for docker:
var factory = new ConnectionFactory
{
    HostName = "host.docker.internal",
    Port = 5672,
    UserName = "guest",
    Password = "guest",
};
/*locally:
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
builder.Services.AddSwaggerGen(
    options =>
    {
        options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
        {
            Description = "Standard Authorization header using the Bearer scheme (\"bearer {token}\")",
            In = ParameterLocation.Header,
            Name = "Authorization",
            Type = SecuritySchemeType.ApiKey
        });

        options.OperationFilter<SecurityRequirementsOperationFilter>();
    }
    );
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder => builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader());
});


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<DiscoverHSCountryContext>(options=>
options.UseSqlServer(connectionString));
builder.Services.AddAutoMapper(typeof(IUserService));
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.UseCors("AllowAllOrigins");


/*using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<DiscoverHSCountryContext>();
    dataContext.Database.Migrate();
}*/
app.Run();
