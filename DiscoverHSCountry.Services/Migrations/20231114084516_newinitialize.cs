using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DiscoverHSCountry.Services.Migrations
{
    /// <inheritdoc />
    public partial class newinitialize : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "City",
                columns: table => new
                {
                    city_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    name = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__City__031491A81E493080", x => x.city_id);
                });

            migrationBuilder.CreateTable(
                name: "EventCategory",
                columns: table => new
                {
                    event_category_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    category_name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__EventCat__5798ECFF60776307", x => x.event_category_id);
                });

            migrationBuilder.CreateTable(
                name: "LocationCategory",
                columns: table => new
                {
                    location_category_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Location__AC3621E3ADC72209", x => x.location_category_id);
                });

            migrationBuilder.CreateTable(
                name: "User",
                columns: table => new
                {
                    user_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    password = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    first_name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    last_name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    profile_image = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__User__B9BE370F7C136D58", x => x.user_id);
                });

            migrationBuilder.CreateTable(
                name: "HistoricalEvent",
                columns: table => new
                {
                    historical_event_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    title = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    city_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Historic__6D7C1E04AF2D9D32", x => x.historical_event_id);
                    table.ForeignKey(
                        name: "FK__Historica__city___2CF2ADDF",
                        column: x => x.city_id,
                        principalTable: "City",
                        principalColumn: "city_id");
                });

            migrationBuilder.CreateTable(
                name: "PublicCityService",
                columns: table => new
                {
                    public_city_service_id = table.Column<int>(type: "int", nullable: false),
                    name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    city_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__PublicCi__AC85DF2F64E031CC", x => x.public_city_service_id);
                    table.ForeignKey(
                        name: "FK__PublicCit__city___5224328E",
                        column: x => x.city_id,
                        principalTable: "City",
                        principalColumn: "city_id");
                });

            migrationBuilder.CreateTable(
                name: "Event",
                columns: table => new
                {
                    event_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    title = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    date = table.Column<DateTime>(type: "date", nullable: false),
                    start_time = table.Column<string>(type: "nvarchar(5)", maxLength: 5, nullable: false),
                    address = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    ticket_cost = table.Column<decimal>(type: "money", nullable: true),
                    city_id = table.Column<int>(type: "int", nullable: true),
                    event_category_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Event__2370F727CA0FAF35", x => x.event_id);
                    table.ForeignKey(
                        name: "FK__Event__city_id__25518C17",
                        column: x => x.city_id,
                        principalTable: "City",
                        principalColumn: "city_id");
                    table.ForeignKey(
                        name: "FK__Event__event_cat__2645B050",
                        column: x => x.event_category_id,
                        principalTable: "EventCategory",
                        principalColumn: "event_category_id");
                });

            migrationBuilder.CreateTable(
                name: "LocationSubcategory",
                columns: table => new
                {
                    location_subcategory_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    location_category_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Location__419D810A25618620", x => x.location_subcategory_id);
                    table.ForeignKey(
                        name: "FK__LocationS__locat__7E37BEF6",
                        column: x => x.location_category_id,
                        principalTable: "LocationCategory",
                        principalColumn: "location_category_id");
                });

            migrationBuilder.CreateTable(
                name: "Administrator",
                columns: table => new
                {
                    administrator_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    user_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Administ__3871E7ACD9FAD8E6", x => x.administrator_id);
                    table.ForeignKey(
                        name: "FK__Administr__user___71D1E811",
                        column: x => x.user_id,
                        principalTable: "User",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "Tourist",
                columns: table => new
                {
                    tourist_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    date_of_birth = table.Column<DateTime>(type: "date", nullable: true),
                    user_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Tourist__83DD92C91BDB1850", x => x.tourist_id);
                    table.ForeignKey(
                        name: "FK__Tourist__user_id__778AC167",
                        column: x => x.user_id,
                        principalTable: "User",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "TouristAttractionOwner",
                columns: table => new
                {
                    tourist_attraction_owner_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    user_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TouristA__3BFDDD96BFD8B586", x => x.tourist_attraction_owner_id);
                    table.ForeignKey(
                        name: "FK__TouristAt__user___74AE54BC",
                        column: x => x.user_id,
                        principalTable: "User",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "Location",
                columns: table => new
                {
                    location_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    cover_image = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    address = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    city_id = table.Column<int>(type: "int", nullable: true),
                    location_category_id = table.Column<int>(type: "int", nullable: true),
                    location_subcategory_id = table.Column<int>(type: "int", nullable: true),
                    FacebookUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    InstagramUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BookingUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsApproved = table.Column<bool>(type: "bit", nullable: false, defaultValueSql: "(CONVERT([bit],(0)))")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Location__771831EA98F9947F", x => x.location_id);
                    table.ForeignKey(
                        name: "FK__Location__city_i__02FC7413",
                        column: x => x.city_id,
                        principalTable: "City",
                        principalColumn: "city_id");
                    table.ForeignKey(
                        name: "FK__Location__locati__03F0984C",
                        column: x => x.location_category_id,
                        principalTable: "LocationCategory",
                        principalColumn: "location_category_id");
                    table.ForeignKey(
                        name: "FK__Location__locati__04E4BC85",
                        column: x => x.location_subcategory_id,
                        principalTable: "LocationSubcategory",
                        principalColumn: "location_subcategory_id");
                });

            migrationBuilder.CreateTable(
                name: "TechnicalIssue_Owner",
                columns: table => new
                {
                    tehnical_issue_owner_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    title = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    tourist_attraction_owner_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Technica__ADF21CDB7A38475E", x => x.tehnical_issue_owner_id);
                    table.ForeignKey(
                        name: "FK__Technical__touri__339FAB6E",
                        column: x => x.tourist_attraction_owner_id,
                        principalTable: "TouristAttractionOwner",
                        principalColumn: "tourist_attraction_owner_id");
                });

            migrationBuilder.CreateTable(
                name: "Event_Location",
                columns: table => new
                {
                    event_id = table.Column<int>(type: "int", nullable: false),
                    location_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Event_Lo__2370F7279BAEF639", x => x.event_id);
                    table.ForeignKey(
                        name: "FK__Event_Loc__event__29221CFB",
                        column: x => x.event_id,
                        principalTable: "Event",
                        principalColumn: "event_id");
                    table.ForeignKey(
                        name: "FK__Event_Loc__locat__2A164134",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                });

            migrationBuilder.CreateTable(
                name: "Location_TouristAttractionOwner",
                columns: table => new
                {
                    location_tourist_attraction_owner_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    tourist_attraction_owner_id = table.Column<int>(type: "int", nullable: true),
                    location_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Location__2F4C1BA510E7EF02", x => x.location_tourist_attraction_owner_id);
                    table.ForeignKey(
                        name: "FK__Location___locat__08B54D69",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                    table.ForeignKey(
                        name: "FK__Location___touri__07C12930",
                        column: x => x.tourist_attraction_owner_id,
                        principalTable: "TouristAttractionOwner",
                        principalColumn: "tourist_attraction_owner_id");
                });

            migrationBuilder.CreateTable(
                name: "LocationImage",
                columns: table => new
                {
                    image_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    location_id = table.Column<int>(type: "int", nullable: true),
                    image = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Location__DC9AC955E88B92D6", x => x.image_id);
                    table.ForeignKey(
                        name: "FK__LocationI__locat__0B91BA14",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                });

            migrationBuilder.CreateTable(
                name: "LocationVisits",
                columns: table => new
                {
                    location_visits_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    location_id = table.Column<int>(type: "int", nullable: false),
                    tourist_id = table.Column<int>(type: "int", nullable: false),
                    number_of_visits = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__LocationVisits__123456", x => x.location_visits_id);
                    table.ForeignKey(
                        name: "FK_LocationVisits_Location",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_LocationVisits_Tourist",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Recommendation",
                columns: table => new
                {
                    recommendation_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    tourist_id = table.Column<int>(type: "int", nullable: false),
                    location_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recommendation__123456", x => x.recommendation_id);
                    table.ForeignKey(
                        name: "FK_Recommendation_Location",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Recommendation_Tourist",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reservation",
                columns: table => new
                {
                    reservation_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    tourist_id = table.Column<int>(type: "int", nullable: true),
                    location_id = table.Column<int>(type: "int", nullable: true),
                    price = table.Column<decimal>(type: "money", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Reservat__31384C29F8D94933", x => x.reservation_id);
                    table.ForeignKey(
                        name: "FK__Reservati__locat__160F4887",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                    table.ForeignKey(
                        name: "FK__Reservati__touri__14270015",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id");
                });

            migrationBuilder.CreateTable(
                name: "Review",
                columns: table => new
                {
                    review_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    title = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    rate = table.Column<double>(type: "float", nullable: false),
                    review_date = table.Column<DateTime>(type: "date", nullable: false),
                    tourist_id = table.Column<int>(type: "int", nullable: true),
                    location_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Review__60883D90245F288E", x => x.review_id);
                    table.ForeignKey(
                        name: "FK__Review__location__208CD6FA",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                    table.ForeignKey(
                        name: "FK__Review__tourist___1F98B2C1",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id");
                });

            migrationBuilder.CreateTable(
                name: "Service",
                columns: table => new
                {
                    service_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    service_name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    service_description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    unit_price = table.Column<decimal>(type: "money", nullable: false),
                    LocationId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Service__3E0DB8AFF7BCF2B5", x => x.service_id);
                    table.ForeignKey(
                        name: "FK_Service_Location",
                        column: x => x.LocationId,
                        principalTable: "Location",
                        principalColumn: "location_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "TechnicalIssue_Tourist",
                columns: table => new
                {
                    tehnical_issue_tourist_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    title = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    tourist_id = table.Column<int>(type: "int", nullable: true),
                    location_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Technica__9A1ACC0471B6D537", x => x.tehnical_issue_tourist_id);
                    table.ForeignKey(
                        name: "FK__Technical__locat__30C33EC3",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                    table.ForeignKey(
                        name: "FK__Technical__touri__2FCF1A8A",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id");
                });

            migrationBuilder.CreateTable(
                name: "VisitedLocation",
                columns: table => new
                {
                    visited_location_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    location_id = table.Column<int>(type: "int", nullable: true),
                    tourist_id = table.Column<int>(type: "int", nullable: true),
                    visit_date = table.Column<DateTime>(type: "date", nullable: true),
                    notes = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VisitedL__1D63958280F68D95", x => x.visited_location_id);
                    table.ForeignKey(
                        name: "FK__VisitedLo__locat__18EBB532",
                        column: x => x.location_id,
                        principalTable: "Location",
                        principalColumn: "location_id");
                    table.ForeignKey(
                        name: "FK__VisitedLo__touri__19DFD96B",
                        column: x => x.tourist_id,
                        principalTable: "Tourist",
                        principalColumn: "tourist_id");
                });

            migrationBuilder.CreateTable(
                name: "ReservationService",
                columns: table => new
                {
                    reservation_service_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    start_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    end_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    number_of_people = table.Column<int>(type: "int", nullable: false),
                    additional_description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    reservation_id = table.Column<int>(type: "int", nullable: false),
                    service_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__ReservationService__YourPrimaryKeyName", x => x.reservation_service_id);
                    table.ForeignKey(
                        name: "FK_ReservationService_Reservation",
                        column: x => x.reservation_id,
                        principalTable: "Reservation",
                        principalColumn: "reservation_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ReservationService_Service",
                        column: x => x.service_id,
                        principalTable: "Service",
                        principalColumn: "service_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "VisitedLocationImage",
                columns: table => new
                {
                    image_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    visited_location_id = table.Column<int>(type: "int", nullable: true),
                    image = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VisitedL__DC9AC95521CC7E9E", x => x.image_id);
                    table.ForeignKey(
                        name: "FK__VisitedLo__visit__1CBC4616",
                        column: x => x.visited_location_id,
                        principalTable: "VisitedLocation",
                        principalColumn: "visited_location_id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Administrator_user_id",
                table: "Administrator",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_Event_city_id",
                table: "Event",
                column: "city_id");

            migrationBuilder.CreateIndex(
                name: "IX_Event_event_category_id",
                table: "Event",
                column: "event_category_id");

            migrationBuilder.CreateIndex(
                name: "IX_Event_Location_location_id",
                table: "Event_Location",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_HistoricalEvent_city_id",
                table: "HistoricalEvent",
                column: "city_id");

            migrationBuilder.CreateIndex(
                name: "IX_Location_city_id",
                table: "Location",
                column: "city_id");

            migrationBuilder.CreateIndex(
                name: "IX_Location_location_category_id",
                table: "Location",
                column: "location_category_id");

            migrationBuilder.CreateIndex(
                name: "IX_Location_location_subcategory_id",
                table: "Location",
                column: "location_subcategory_id");

            migrationBuilder.CreateIndex(
                name: "IX_Location_TouristAttractionOwner_location_id",
                table: "Location_TouristAttractionOwner",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_Location_TouristAttractionOwner_tourist_attraction_owner_id",
                table: "Location_TouristAttractionOwner",
                column: "tourist_attraction_owner_id");

            migrationBuilder.CreateIndex(
                name: "IX_LocationImage_location_id",
                table: "LocationImage",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_LocationSubcategory_location_category_id",
                table: "LocationSubcategory",
                column: "location_category_id");

            migrationBuilder.CreateIndex(
                name: "IX_LocationVisits_location_id",
                table: "LocationVisits",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_LocationVisits_tourist_id",
                table: "LocationVisits",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_PublicCityService_city_id",
                table: "PublicCityService",
                column: "city_id");

            migrationBuilder.CreateIndex(
                name: "IX_Recommendation_location_id",
                table: "Recommendation",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_Recommendation_tourist_id",
                table: "Recommendation",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_location_id",
                table: "Reservation",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_tourist_id",
                table: "Reservation",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationService_reservation_id",
                table: "ReservationService",
                column: "reservation_id");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationService_service_id",
                table: "ReservationService",
                column: "service_id");

            migrationBuilder.CreateIndex(
                name: "IX_Review_location_id",
                table: "Review",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_Review_tourist_id",
                table: "Review",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_Service_LocationId",
                table: "Service",
                column: "LocationId");

            migrationBuilder.CreateIndex(
                name: "IX_TechnicalIssue_Owner_tourist_attraction_owner_id",
                table: "TechnicalIssue_Owner",
                column: "tourist_attraction_owner_id");

            migrationBuilder.CreateIndex(
                name: "IX_TechnicalIssue_Tourist_location_id",
                table: "TechnicalIssue_Tourist",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_TechnicalIssue_Tourist_tourist_id",
                table: "TechnicalIssue_Tourist",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_Tourist_user_id",
                table: "Tourist",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_TouristAttractionOwner_user_id",
                table: "TouristAttractionOwner",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_VisitedLocation_location_id",
                table: "VisitedLocation",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_VisitedLocation_tourist_id",
                table: "VisitedLocation",
                column: "tourist_id");

            migrationBuilder.CreateIndex(
                name: "IX_VisitedLocationImage_visited_location_id",
                table: "VisitedLocationImage",
                column: "visited_location_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Administrator");

            migrationBuilder.DropTable(
                name: "Event_Location");

            migrationBuilder.DropTable(
                name: "HistoricalEvent");

            migrationBuilder.DropTable(
                name: "Location_TouristAttractionOwner");

            migrationBuilder.DropTable(
                name: "LocationImage");

            migrationBuilder.DropTable(
                name: "LocationVisits");

            migrationBuilder.DropTable(
                name: "PublicCityService");

            migrationBuilder.DropTable(
                name: "Recommendation");

            migrationBuilder.DropTable(
                name: "ReservationService");

            migrationBuilder.DropTable(
                name: "Review");

            migrationBuilder.DropTable(
                name: "TechnicalIssue_Owner");

            migrationBuilder.DropTable(
                name: "TechnicalIssue_Tourist");

            migrationBuilder.DropTable(
                name: "VisitedLocationImage");

            migrationBuilder.DropTable(
                name: "Event");

            migrationBuilder.DropTable(
                name: "Reservation");

            migrationBuilder.DropTable(
                name: "Service");

            migrationBuilder.DropTable(
                name: "TouristAttractionOwner");

            migrationBuilder.DropTable(
                name: "VisitedLocation");

            migrationBuilder.DropTable(
                name: "EventCategory");

            migrationBuilder.DropTable(
                name: "Location");

            migrationBuilder.DropTable(
                name: "Tourist");

            migrationBuilder.DropTable(
                name: "City");

            migrationBuilder.DropTable(
                name: "LocationSubcategory");

            migrationBuilder.DropTable(
                name: "User");

            migrationBuilder.DropTable(
                name: "LocationCategory");
        }
    }
}
