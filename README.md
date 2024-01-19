# DiscoverHSCountry

Discover Heart-Shaped Country is an app made for three types of users: admin, tourist attraction owner, and tourist. Admin and tourist attraction owners use the desktop side of the app and tourists use the mobile app. 
Admin can add new locations, events, historical stories, and public city services while taking care of approving new locations added by tourist attraction owners and handling reported issues from tourist attraction owners and tourists. 
Tourist attraction owners add only their locations and events on their locations. They are business owners, people who want to use this app to get tourists to visit their locations and reserve or use their services. For each location they add, they can add services (for example, hotels can have services such as single or double rooms). They can add events and prices of tickets for their events but those are not meant to be reserved from the app, only services on locations. 
Tourists are able to see details on both types of locations: those added by admin (general locations like rivers, mountains etc.) and those added by tourist attraction owners (hotels, rafting businesses, shops etc.). They can check out public city services such as ATMs or bus timetables in cities in Bosnia and Herzegovina. They are also able to check out historical stories and events. Most importantly, they can make reservations from the app for services at locations added by tourist attraction owners. 

The process for making a reservation is as follows:
1. Log in as a tourist on the mobile app
2. Select any city from the homepage or from right-sided drawer options to see all cities or location categories
3. Once you click on the city (or location category -> location subcategory) you'll see locations by that criterium
4. For example, you can reserve service from a hotel by clicking reserve on the location details page in section services
5. You can go to checkout or add more services from the same location
6. When you do checkout, you'll see the total amount of your reservation and all other details in your cart
7. Proceeding to pay will lead you to PayPal service where you can use Sandbox for paying (credentials below)
8. After successful payment, you'll be redirected back to the app where you can continue using its features
9. Your reservations can be found by clicking the "My Reservations" option in the right-sided drawer menu

    NOTE: The PayPal package for Flutter needs to use web view so it will only work on connected mobile devices or mobile phone emulators since there you have the option to be redirected from the app to your default browser when the PayPal screen is opened.

Desktop app admin credentials:
- Email : admin@admin.com
- Password : Admin123! 

Desktop app tourist attraction owner credentials: 
- Email : test@test.com
- Password : Test123.

Mobile app tourist credentials: 
- Email : tourist@tourist.com
- Password : Tourist123.

PayPal sandbox account for paying: 
- Email : sb-q43hx4326705584@business.example.com
- Password : 7kD&98A@


