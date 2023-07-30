using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IVisitedLocationImageService : ICRUDService<Model.VisitedLocationImage, Model.SearchObjects.VisitedLocationImageSearchObject, Model.Requests.VisitedLocationImageCreateRequest, Model.Requests.VisitedLocationImageUpdateRequest>
    {
    }
}
