using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DiscoverHSCountry.Services.Migrations
{
    /// <inheritdoc />
    public partial class addedLocationVisits : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.CreateIndex(
                name: "IX_LocationVisits_location_id",
                table: "LocationVisits",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_LocationVisits_tourist_id",
                table: "LocationVisits",
                column: "tourist_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "LocationVisits");
        }
    }
}
