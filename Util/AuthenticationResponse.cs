namespace Util
{
    public enum AuthenticationResult
    {
        Success,
        UserNotFound,
        InvalidPassword
    }

    public class AuthenticationResponse
    {
        public AuthenticationResult Result { get; set; }
        public int? UserId { get; set; }
        public string? Token { get; set; }
    }
}