using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IReviewService : ICRUDService<Model.Review, Model.SearchObjects.ReviewSearchObject, Model.Requests.ReviewCreateRequest, Model.Requests.ReviewUpdateRequest>
    {
    }
}
