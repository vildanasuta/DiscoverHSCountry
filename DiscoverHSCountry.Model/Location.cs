using System;
using System.Collections.Generic;
namespace DiscoverHSCountry.Model
{
    public partial class Location
    {
        public int LocationId { get; set; }

        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public string? CoverImage { get; set; }

        public string Address { get; set; } = null!;

        public int? CityId { get; set; }

        public int? LocationCategoryId { get; set; }

        public int? LocationSubcategoryId { get; set; }

        public virtual City? City { get; set; }

        public virtual ICollection<EventLocation> EventLocations { get; set; } = new List<EventLocation>();

        public virtual LocationCategory? LocationCategory { get; set; }

        public virtual ICollection<LocationImage> LocationImages { get; set; } = new List<LocationImage>();

        public virtual LocationSubcategory? LocationSubcategory { get; set; }

        public virtual ICollection<LocationTouristAttractionOwner> LocationTouristAttractionOwners { get; set; } = new List<LocationTouristAttractionOwner>();

        public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

        public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

        public virtual ICollection<SocialMediaLocation> SocialMediaLocations { get; set; } = new List<SocialMediaLocation>();

        public virtual ICollection<TechnicalIssueTourist> TechnicalIssueTourists { get; set; } = new List<TechnicalIssueTourist>();

        public virtual ICollection<VisitedLocation> VisitedLocations { get; set; } = new List<VisitedLocation>();
    }
}