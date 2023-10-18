using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DiscoverHSCountry.Services.Migrations
{
    /// <inheritdoc />
    public partial class addRecommendationTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.CreateIndex(
                name: "IX_Recommendation_location_id",
                table: "Recommendation",
                column: "location_id");

            migrationBuilder.CreateIndex(
                name: "IX_Recommendation_tourist_id",
                table: "Recommendation",
                column: "tourist_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Recommendation");
        }
    }
}
