using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DiscoverHSCountry.Services.Migrations
{
    /// <inheritdoc />
    public partial class makeReservationsWork : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK__Reservati__servi__151B244E",
                table: "Reservation");

            migrationBuilder.DropIndex(
                name: "IX_Reservation_service_id",
                table: "Reservation");

            migrationBuilder.DropColumn(
                name: "additional_description",
                table: "Reservation");

            migrationBuilder.DropColumn(
                name: "end_date",
                table: "Reservation");

            migrationBuilder.DropColumn(
                name: "number_of_people",
                table: "Reservation");

            migrationBuilder.DropColumn(
                name: "service_id",
                table: "Reservation");

            migrationBuilder.DropColumn(
                name: "start_date",
                table: "Reservation");

            migrationBuilder.AddColumn<string>(
                name: "service_description",
                table: "Service",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "unit_price",
                table: "Service",
                type: "money",
                nullable: false,
                defaultValue: 0m);

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

            migrationBuilder.CreateIndex(
                name: "IX_ReservationService_reservation_id",
                table: "ReservationService",
                column: "reservation_id");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationService_service_id",
                table: "ReservationService",
                column: "service_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ReservationService");

            migrationBuilder.DropColumn(
                name: "service_description",
                table: "Service");

            migrationBuilder.DropColumn(
                name: "unit_price",
                table: "Service");

            migrationBuilder.AddColumn<string>(
                name: "additional_description",
                table: "Reservation",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "end_date",
                table: "Reservation",
                type: "date",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<int>(
                name: "number_of_people",
                table: "Reservation",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "service_id",
                table: "Reservation",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "start_date",
                table: "Reservation",
                type: "date",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_service_id",
                table: "Reservation",
                column: "service_id");

            migrationBuilder.AddForeignKey(
                name: "FK__Reservati__servi__151B244E",
                table: "Reservation",
                column: "service_id",
                principalTable: "Service",
                principalColumn: "service_id");
        }
    }
}
