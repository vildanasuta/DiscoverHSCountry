using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DiscoverHSCountry.Services.Migrations
{
    /// <inheritdoc />
    public partial class addIsApprovedLocation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsApproved",
                table: "Location",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsApproved",
                table: "Location");
        }
    }
}
