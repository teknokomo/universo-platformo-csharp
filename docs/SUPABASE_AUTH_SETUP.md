# Supabase Authentication Setup Guide

## Configuration Steps

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Note your project URL and anon/public key

### 2. Configure Application

Edit `src/packages/main-frt/base/wwwroot/appsettings.json`:

```json
{
  "Supabase": {
    "Url": "https://your-project-id.supabase.co",
    "Key": "your-anon-key-here",
    "AutoRefreshToken": true,
    "PersistSession": true
  }
}
```

### 3. Build and Run

```powershell
# From repository root
dotnet build
dotnet run --project src/packages/main-frt/base
```

## Testing the Authentication Flow

### Sign Up Flow
1. Navigate to `/register`
2. Enter email and password (min 6 characters)
3. Check your email for confirmation link
4. Confirm email in Supabase dashboard (if needed)

### Sign In Flow
1. Navigate to `/login`
2. Enter your credentials
3. After successful login, you'll be redirected to home page

### Protected Routes
1. Try accessing `/protected` without logging in
2. You should be redirected to `/login`
3. After login, access `/protected` to see your user info

### Sign Out
1. Click on the user menu in the top-right corner
2. Select "Logout"
3. You'll be signed out and redirected to home

## Features Implemented

- ✅ Email/password registration
- ✅ Email/password login
- ✅ Session management with auto-refresh
- ✅ Protected routes with `[Authorize]` attribute
- ✅ User menu with logout
- ✅ AuthenticationStateProvider integration
- ✅ MudBlazor UI components

## Package Version

- supabase-csharp: 0.16.2

## Package Structure

```
src/packages/
├── auth-srv/base/          # Authentication service
│   ├── Configuration/      # Supabase settings
│   ├── Interfaces/         # IAuthService
│   ├── Models/             # DTOs and models
│   └── Services/           # Auth implementation
└── main-frt/base/          # Main frontend app
    ├── Components/         # LoginMenu, RedirectToLogin
    └── Pages/              # Login, Register, Protected
```

## Security Notes

⚠️ **Important:**
- Never commit real Supabase credentials to git
- Use environment variables or secure vaults in production
- The `appsettings.json` in wwwroot is client-accessible
- For production, implement server-side API proxy

## Troubleshooting

### Email not confirmed
- Check Supabase dashboard > Authentication > Users
- Manually confirm user if needed for testing

### Session not persisting
- Ensure `PersistSession: true` in settings
- Check browser console for errors

### CORS errors
- Verify Supabase project URL is correct
- Check Supabase project settings for CORS configuration
