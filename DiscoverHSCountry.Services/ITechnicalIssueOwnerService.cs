using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ITechnicalIssueOwnerService : ICRUDService<Model.TechnicalIssueOwner, Model.SearchObjects.TechnicalIssueOwnerSearchObject, Model.Requests.TechnicalIssueOwnerCreateRequest, Model.Requests.TechnicalIssueOwnerUpdateRequest>
    {
    }
}
