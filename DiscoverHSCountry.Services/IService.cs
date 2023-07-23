using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IService<T, TSearch> where TSearch : class
    {
        Task<Model.PagedResult<T>> Get(TSearch search = null);
        Task<T> GetById(int id);
    }
}
