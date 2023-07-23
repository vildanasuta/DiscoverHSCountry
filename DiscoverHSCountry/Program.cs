using DiscoverHSCountry.Services;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using DiscoverHSCountry.Model;
using System.Text.Json.Serialization;

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

app.Run();
