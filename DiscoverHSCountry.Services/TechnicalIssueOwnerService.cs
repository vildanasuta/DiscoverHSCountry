using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class TechnicalIssueOwnerService : BaseCRUDService<Model.TechnicalIssueOwner, Database.TechnicalIssueOwner, TechnicalIssueOwnerSearchObject, TechnicalIssueOwnerCreateRequest, TechnicalIssueOwnerUpdateRequest>, ITechnicalIssueOwnerService
    {
        public TechnicalIssueOwnerService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
