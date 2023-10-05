using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace DiscoverHSCountry.Services.Database;

public partial class DiscoverHSCountryContext : DbContext
{
    public DiscoverHSCountryContext()
    {
    }

    public DiscoverHSCountryContext(DbContextOptions<DiscoverHSCountryContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Administrator> Administrators { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Event> Events { get; set; }

    public virtual DbSet<EventCategory> EventCategories { get; set; }

    public virtual DbSet<EventLocation> EventLocations { get; set; }

    public virtual DbSet<HistoricalEvent> HistoricalEvents { get; set; }

    public virtual DbSet<Location> Locations { get; set; }

    public virtual DbSet<LocationCategory> LocationCategories { get; set; }

    public virtual DbSet<LocationImage> LocationImages { get; set; }

    public virtual DbSet<LocationSubcategory> LocationSubcategories { get; set; }

    public virtual DbSet<LocationTouristAttractionOwner> LocationTouristAttractionOwners { get; set; }

    public virtual DbSet<PublicCityService> PublicCityServices { get; set; }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Service> Services { get; set; }

    public virtual DbSet<TechnicalIssueOwner> TechnicalIssueOwners { get; set; }

    public virtual DbSet<TechnicalIssueTourist> TechnicalIssueTourists { get; set; }

    public virtual DbSet<Tourist> Tourists { get; set; }

    public virtual DbSet<TouristAttractionOwner> TouristAttractionOwners { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<VisitedLocation> VisitedLocations { get; set; }

    public virtual DbSet<VisitedLocationImage> VisitedLocationImages { get; set; }

    /*protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=CS613;Integrated Security=True;Connect Timeout=30;Encrypt=False;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False;Initial Catalog=DiscoverHSCountry");
*/

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Administrator>(entity =>
        {
            entity.HasKey(e => e.AdministratorId).HasName("PK__Administ__3871E7ACD9FAD8E6");

            entity.ToTable("Administrator");
            
            entity.HasIndex(e => e.UserId, "IX_Administrator_user_id");

            entity.Property(e => e.AdministratorId).HasColumnName("administrator_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Administrators)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Administr__user___71D1E811");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.CityId).HasName("PK__City__031491A81E493080");

            entity.ToTable("City");

            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.Name)
                .HasMaxLength(20)
                .HasColumnName("name");
        });

        modelBuilder.Entity<Event>(entity =>
        {
            entity.HasKey(e => e.EventId).HasName("PK__Event__2370F727CA0FAF35");

            entity.ToTable("Event");

            entity.HasIndex(e => e.CityId, "IX_Event_city_id");

            entity.HasIndex(e => e.EventCategoryId, "IX_Event_event_category_id");

            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasColumnName("address");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.Date)
                .HasColumnType("date")
                .HasColumnName("date");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.EventCategoryId).HasColumnName("event_category_id");
            entity.Property(e => e.StartTime)
                .HasMaxLength(5)
                .HasColumnName("start_time");
            entity.Property(e => e.TicketCost)
                .HasColumnType("money")
                .HasColumnName("ticket_cost");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasColumnName("title");

            entity.HasOne(d => d.City).WithMany(p => p.Events)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__Event__city_id__25518C17");

            entity.HasOne(d => d.EventCategory).WithMany(p => p.Events)
                .HasForeignKey(d => d.EventCategoryId)
                .HasConstraintName("FK__Event__event_cat__2645B050");
        });

        modelBuilder.Entity<EventCategory>(entity =>
        {
            entity.HasKey(e => e.EventCategoryId).HasName("PK__EventCat__5798ECFF60776307");

            entity.ToTable("EventCategory");

            entity.Property(e => e.EventCategoryId).HasColumnName("event_category_id");
            entity.Property(e => e.CategoryName)
                .HasMaxLength(100)
                .HasColumnName("category_name");
        });

        modelBuilder.Entity<EventLocation>(entity =>
        {
            entity.HasKey(e => e.EventId).HasName("PK__Event_Lo__2370F7279BAEF639");

            entity.ToTable("Event_Location");

            entity.HasIndex(e => e.LocationId, "IX_Event_Location_location_id");

            entity.Property(e => e.EventId)
                .ValueGeneratedNever()
                .HasColumnName("event_id");
            entity.Property(e => e.LocationId).HasColumnName("location_id");

            entity.HasOne(d => d.Event).WithOne(p => p.EventLocation)
                .HasForeignKey<EventLocation>(d => d.EventId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Event_Loc__event__29221CFB");

            entity.HasOne(d => d.Location).WithMany(p => p.EventLocations)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__Event_Loc__locat__2A164134");
        });

        modelBuilder.Entity<HistoricalEvent>(entity =>
        {
            entity.HasKey(e => e.HistoricalEventId).HasName("PK__Historic__6D7C1E04AF2D9D32");

            entity.ToTable("HistoricalEvent");

            entity.HasIndex(e => e.CityId, "IX_HistoricalEvent_city_id");

            entity.Property(e => e.HistoricalEventId).HasColumnName("historical_event_id");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasColumnName("title");

            entity.HasOne(d => d.City).WithMany(p => p.HistoricalEvents)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__Historica__city___2CF2ADDF");
        });

        modelBuilder.Entity<Location>(entity =>
        {
            entity.HasKey(e => e.LocationId).HasName("PK__Location__771831EA98F9947F");

            entity.ToTable("Location");

            entity.HasIndex(e => e.CityId, "IX_Location_city_id");

            entity.HasIndex(e => e.LocationCategoryId, "IX_Location_location_category_id");

            entity.HasIndex(e => e.LocationSubcategoryId, "IX_Location_location_subcategory_id");

            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.Address)
                .HasMaxLength(100)
                .HasColumnName("address");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.IsApproved)
                .IsRequired()
                .HasDefaultValueSql("(CONVERT([bit],(0)))");
            entity.Property(e => e.LocationCategoryId).HasColumnName("location_category_id");
            entity.Property(e => e.LocationSubcategoryId).HasColumnName("location_subcategory_id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");

            entity.HasOne(d => d.City).WithMany(p => p.Locations)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__Location__city_i__02FC7413");

            entity.HasOne(d => d.LocationCategory).WithMany(p => p.Locations)
                .HasForeignKey(d => d.LocationCategoryId)
                .HasConstraintName("FK__Location__locati__03F0984C");

            entity.HasOne(d => d.LocationSubcategory).WithMany(p => p.Locations)
                .HasForeignKey(d => d.LocationSubcategoryId)
                .HasConstraintName("FK__Location__locati__04E4BC85");
        });

        modelBuilder.Entity<LocationCategory>(entity =>
        {
            entity.HasKey(e => e.LocationCategoryId).HasName("PK__Location__AC3621E3ADC72209");

            entity.ToTable("LocationCategory");

            entity.Property(e => e.LocationCategoryId).HasColumnName("location_category_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
        });

        modelBuilder.Entity<LocationImage>(entity =>
        {
            entity.HasKey(e => e.ImageId).HasName("PK__Location__DC9AC955E88B92D6");

            entity.ToTable("LocationImage");

            entity.HasIndex(e => e.LocationId, "IX_LocationImage_location_id");

            entity.Property(e => e.ImageId).HasColumnName("image_id");
            entity.Property(e => e.Image).HasColumnName("image");
            entity.Property(e => e.LocationId).HasColumnName("location_id");

            entity.HasOne(d => d.Location).WithMany(p => p.LocationImages)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__LocationI__locat__0B91BA14");
        });

        modelBuilder.Entity<LocationSubcategory>(entity =>
        {
            entity.HasKey(e => e.LocationSubcategoryId).HasName("PK__Location__419D810A25618620");

            entity.ToTable("LocationSubcategory");

            entity.HasIndex(e => e.LocationCategoryId, "IX_LocationSubcategory_location_category_id");

            entity.Property(e => e.LocationSubcategoryId).HasColumnName("location_subcategory_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.LocationCategoryId).HasColumnName("location_category_id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");

            entity.HasOne(d => d.LocationCategory).WithMany(p => p.LocationSubcategories)
                .HasForeignKey(d => d.LocationCategoryId)
                .HasConstraintName("FK__LocationS__locat__7E37BEF6");
        });

        modelBuilder.Entity<LocationTouristAttractionOwner>(entity =>
        {
            entity.HasKey(e => e.LocationTouristAttractionOwnerId).HasName("PK__Location__2F4C1BA510E7EF02");

            entity.ToTable("Location_TouristAttractionOwner");

            entity.HasIndex(e => e.LocationId, "IX_Location_TouristAttractionOwner_location_id");

            entity.HasIndex(e => e.TouristAttractionOwnerId, "IX_Location_TouristAttractionOwner_tourist_attraction_owner_id");

            entity.Property(e => e.LocationTouristAttractionOwnerId).HasColumnName("location_tourist_attraction_owner_id");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.TouristAttractionOwnerId).HasColumnName("tourist_attraction_owner_id");

            entity.HasOne(d => d.Location).WithMany(p => p.LocationTouristAttractionOwners)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__Location___locat__08B54D69");

            entity.HasOne(d => d.TouristAttractionOwner).WithMany(p => p.LocationTouristAttractionOwners)
                .HasForeignKey(d => d.TouristAttractionOwnerId)
                .HasConstraintName("FK__Location___touri__07C12930");
        });

        modelBuilder.Entity<PublicCityService>(entity =>
        {
            entity.HasKey(e => e.PublicCityServiceId).HasName("PK__PublicCi__AC85DF2F64E031CC");

            entity.ToTable("PublicCityService");

            entity.Property(e => e.PublicCityServiceId)
                .ValueGeneratedNever()
                .HasColumnName("public_city_service_id");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CoverImage).HasColumnName("cover_image");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.Name).HasColumnName("name");

            entity.HasOne(d => d.City).WithMany(p => p.PublicCityServices)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__PublicCit__city___5224328E");
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.ReservationId).HasName("PK__Reservat__31384C29F8D94933");

            entity.ToTable("Reservation");

            entity.HasIndex(e => e.LocationId, "IX_Reservation_location_id");

            entity.HasIndex(e => e.ServiceId, "IX_Reservation_service_id");

            entity.HasIndex(e => e.TouristId, "IX_Reservation_tourist_id");

            entity.Property(e => e.ReservationId).HasColumnName("reservation_id");
            entity.Property(e => e.AdditionalDescription)
                .HasMaxLength(200)
                .HasColumnName("additional_description");
            entity.Property(e => e.EndDate)
                .HasColumnType("date")
                .HasColumnName("end_date");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.NumberOfPeople).HasColumnName("number_of_people");
            entity.Property(e => e.Price)
                .HasColumnType("money")
                .HasColumnName("price");
            entity.Property(e => e.ServiceId).HasColumnName("service_id");
            entity.Property(e => e.StartDate)
                .HasColumnType("date")
                .HasColumnName("start_date");
            entity.Property(e => e.TouristId).HasColumnName("tourist_id");

            entity.HasOne(d => d.Location).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__Reservati__locat__160F4887");

            entity.HasOne(d => d.Service).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.ServiceId)
                .HasConstraintName("FK__Reservati__servi__151B244E");

            entity.HasOne(d => d.Tourist).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.TouristId)
                .HasConstraintName("FK__Reservati__touri__14270015");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.ReviewId).HasName("PK__Review__60883D90245F288E");

            entity.ToTable("Review");

            entity.HasIndex(e => e.LocationId, "IX_Review_location_id");

            entity.HasIndex(e => e.TouristId, "IX_Review_tourist_id");

            entity.Property(e => e.ReviewId).HasColumnName("review_id");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.Rate).HasColumnName("rate");
            entity.Property(e => e.ReviewDate)
                .HasColumnType("date")
                .HasColumnName("review_date");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasColumnName("title");
            entity.Property(e => e.TouristId).HasColumnName("tourist_id");

            entity.HasOne(d => d.Location).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__Review__location__208CD6FA");

            entity.HasOne(d => d.Tourist).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.TouristId)
                .HasConstraintName("FK__Review__tourist___1F98B2C1");
        });

        modelBuilder.Entity<Service>(entity =>
        {
            entity.HasKey(e => e.ServiceId).HasName("PK__Service__3E0DB8AFF7BCF2B5");

            entity.ToTable("Service");

            entity.Property(e => e.ServiceId).HasColumnName("service_id");
            entity.Property(e => e.ServiceName)
                .HasMaxLength(100)
                .HasColumnName("service_name");
        });

        modelBuilder.Entity<TechnicalIssueOwner>(entity =>
        {
            entity.HasKey(e => e.TehnicalIssueOwnerId).HasName("PK__Technica__ADF21CDB7A38475E");

            entity.ToTable("TechnicalIssue_Owner");

            entity.HasIndex(e => e.TouristAttractionOwnerId, "IX_TechnicalIssue_Owner_tourist_attraction_owner_id");

            entity.Property(e => e.TehnicalIssueOwnerId).HasColumnName("tehnical_issue_owner_id");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasColumnName("title");
            entity.Property(e => e.TouristAttractionOwnerId).HasColumnName("tourist_attraction_owner_id");

            entity.HasOne(d => d.TouristAttractionOwner).WithMany(p => p.TechnicalIssueOwners)
                .HasForeignKey(d => d.TouristAttractionOwnerId)
                .HasConstraintName("FK__Technical__touri__339FAB6E");
        });

        modelBuilder.Entity<TechnicalIssueTourist>(entity =>
        {
            entity.HasKey(e => e.TehnicalIssueTouristId).HasName("PK__Technica__9A1ACC0471B6D537");

            entity.ToTable("TechnicalIssue_Tourist");

            entity.HasIndex(e => e.LocationId, "IX_TechnicalIssue_Tourist_location_id");

            entity.HasIndex(e => e.TouristId, "IX_TechnicalIssue_Tourist_tourist_id");

            entity.Property(e => e.TehnicalIssueTouristId).HasColumnName("tehnical_issue_tourist_id");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasColumnName("title");
            entity.Property(e => e.TouristId).HasColumnName("tourist_id");

            entity.HasOne(d => d.Location).WithMany(p => p.TechnicalIssueTourists)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__Technical__locat__30C33EC3");

            entity.HasOne(d => d.Tourist).WithMany(p => p.TechnicalIssueTourists)
                .HasForeignKey(d => d.TouristId)
                .HasConstraintName("FK__Technical__touri__2FCF1A8A");
        });

        modelBuilder.Entity<Tourist>(entity =>
        {
            entity.HasKey(e => e.TouristId).HasName("PK__Tourist__83DD92C91BDB1850");

            entity.ToTable("Tourist");

            entity.HasIndex(e => e.UserId, "IX_Tourist_user_id");

            entity.Property(e => e.TouristId).HasColumnName("tourist_id");
            entity.Property(e => e.DateOfBirth)
                .HasColumnType("date")
                .HasColumnName("date_of_birth");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Tourists)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__Tourist__user_id__778AC167");
        });

        modelBuilder.Entity<TouristAttractionOwner>(entity =>
        {
            entity.HasKey(e => e.TouristAttractionOwnerId).HasName("PK__TouristA__3BFDDD96BFD8B586");

            entity.ToTable("TouristAttractionOwner");

            entity.HasIndex(e => e.UserId, "IX_TouristAttractionOwner_user_id");

            entity.Property(e => e.TouristAttractionOwnerId).HasColumnName("tourist_attraction_owner_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.TouristAttractionOwners)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__TouristAt__user___74AE54BC");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__User__B9BE370F7C136D58");

            entity.ToTable("User");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .HasColumnName("email");
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(50)
                .HasColumnName("last_name");
            entity.Property(e => e.Password)
                .HasMaxLength(200)
                .HasColumnName("password");
            entity.Property(e => e.ProfileImage).HasColumnName("profile_image");
        });

        modelBuilder.Entity<VisitedLocation>(entity =>
        {
            entity.HasKey(e => e.VisitedLocationId).HasName("PK__VisitedL__1D63958280F68D95");

            entity.ToTable("VisitedLocation");

            entity.HasIndex(e => e.LocationId, "IX_VisitedLocation_location_id");

            entity.HasIndex(e => e.TouristId, "IX_VisitedLocation_tourist_id");

            entity.Property(e => e.VisitedLocationId).HasColumnName("visited_location_id");
            entity.Property(e => e.LocationId).HasColumnName("location_id");
            entity.Property(e => e.Notes)
                .HasMaxLength(200)
                .HasColumnName("notes");
            entity.Property(e => e.TouristId).HasColumnName("tourist_id");
            entity.Property(e => e.VisitDate)
                .HasColumnType("date")
                .HasColumnName("visit_date");

            entity.HasOne(d => d.Location).WithMany(p => p.VisitedLocations)
                .HasForeignKey(d => d.LocationId)
                .HasConstraintName("FK__VisitedLo__locat__18EBB532");

            entity.HasOne(d => d.Tourist).WithMany(p => p.VisitedLocations)
                .HasForeignKey(d => d.TouristId)
                .HasConstraintName("FK__VisitedLo__touri__19DFD96B");
        });

        modelBuilder.Entity<VisitedLocationImage>(entity =>
        {
            entity.HasKey(e => e.ImageId).HasName("PK__VisitedL__DC9AC95521CC7E9E");

            entity.ToTable("VisitedLocationImage");

            entity.HasIndex(e => e.VisitedLocationId, "IX_VisitedLocationImage_visited_location_id");

            entity.Property(e => e.ImageId).HasColumnName("image_id");
            entity.Property(e => e.Image).HasColumnName("image");
            entity.Property(e => e.VisitedLocationId).HasColumnName("visited_location_id");

            entity.HasOne(d => d.VisitedLocation).WithMany(p => p.VisitedLocationImages)
                .HasForeignKey(d => d.VisitedLocationId)
                .HasConstraintName("FK__VisitedLo__visit__1CBC4616");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
 