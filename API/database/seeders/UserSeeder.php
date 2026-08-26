<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Salon;
use App\Models\Individual;
use App\Models\Cities;
use App\Models\Category;
use App\Models\Settings;
use App\Models\Banners;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Clear existing users/salons/individuals/cities/categories/settings/banners
        User::whereIn('email', ['admin@mytrim.com', 'user@mytrim.com', 'owner@mytrim.com', 'freelancer@mytrim.com'])->delete();
        Cities::truncate();
        Category::truncate();
        Settings::truncate();
        Banners::truncate();
        Individual::truncate();
        Salon::truncate();

        // 2. Admin User
        $admin = User::create([
            'first_name' => 'MyTrim',
            'last_name' => 'Admin',
            'email' => 'admin@mytrim.com',
            'password' => Hash::make('password'),
            'country_code' => '+91',
            'mobile' => '1234567890',
            'type' => 'admin',
            'status' => 1,
        ]);

        // 3. Normal User (User App)
        $user = User::create([
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => 'user@mytrim.com',
            'password' => Hash::make('password'),
            'country_code' => '+91',
            'mobile' => '9876543210',
            'type' => 'user',
            'status' => 1,
        ]);

        // 4. Salon Owner (Owner App)
        $owner = User::create([
            'first_name' => 'Salon',
            'last_name' => 'Owner',
            'email' => 'owner@mytrim.com',
            'password' => Hash::make('password'),
            'country_code' => '+91',
            'mobile' => '8765432109',
            'type' => 'salon',
            'status' => 1,
        ]);

        // Create the Salon profile for the owner (with all non-null field defaults)
        Salon::create([
            'uid' => $owner->id,
            'name' => 'My Dream Salon',
            'cover' => 'default.png',
            'categories' => '1,2,3',
            'address' => '123 Main Street, Bhavnagar, Gujarat, India',
            'lat' => '21.7645',
            'lng' => '72.1519',
            'cid' => 1,
            'rating' => 0.0,
            'total_rating' => 0,
            'service_at_home' => 1,
            'verified' => 1,
            'in_home' => 1,
            'popular' => 1,
            'have_shop' => 1,
            'have_stylist' => 1,
            'status' => 1,
        ]);

        // 5. Freelancer (Owner App)
        $freelancer = User::create([
            'first_name' => 'Jane',
            'last_name' => 'Freelancer',
            'email' => 'freelancer@mytrim.com',
            'password' => Hash::make('password'),
            'country_code' => '+91',
            'mobile' => '7654321098',
            'type' => 'individual',
            'status' => 1,
        ]);

        // Create the Individual profile for the freelancer (with all non-null field defaults)
        Individual::create([
            'uid' => $freelancer->id,
            'background' => 'default.png',
            'categories' => '1,2,3',
            'address' => '456 Side Street, Bhavnagar, Gujarat, India',
            'lat' => '21.7645',
            'lng' => '72.1519',
            'cid' => 1,
            'rating' => 0.0,
            'fee_start' => 50,
            'total_rating' => 0,
            'verified' => 1,
            'in_home' => 1,
            'popular' => 1,
            'have_shop' => 1,
            'status' => 1,
        ]);

        // 6. Cities
        $city = Cities::create([
            'id' => 1,
            'name' => 'Bhavnagar',
            'lat' => '21.7645',
            'lng' => '72.1519',
            'status' => 1,
        ]);

        // 7. Categories
        Category::create([
            'id' => 1,
            'name' => 'Haircut',
            'cover' => 'haircut.png',
            'status' => 1,
        ]);
        Category::create([
            'id' => 2,
            'name' => 'Shaving',
            'cover' => 'shaving.png',
            'status' => 1,
        ]);
        Category::create([
            'id' => 3,
            'name' => 'Facial',
            'cover' => 'facial.png',
            'status' => 1,
        ]);

        // 8. Banners
        Banners::create([
            'id' => 1,
            'city_id' => 1,
            'cover' => 'banner1.png',
            'type' => 0,
            'value' => '1',
            'title' => 'Special Salon Offer',
            'from' => '2026-01-01',
            'to' => '2030-12-31',
            'status' => 1,
        ]);

        // 9. Settings
        Settings::create([
            'id' => 1,
            'name' => 'MyTrim',
            'mobile' => '1234567890',
            'email' => 'support@mytrim.com',
            'address' => 'Bhavnagar, Gujarat, India',
            'city' => 'Bhavnagar',
            'state' => 'Gujarat',
            'zip' => '364001',
            'country' => 'India',
            'tax' => 5.0,
            'delivery_charge' => 10.0,
            'currencySymbol' => '$',
            'currencySide' => 'left',
            'currencyCode' => 'USD',
            'appDirection' => 'ltr',
            'logo' => 'logo.png',
            'sms_name' => 'default',
            'sms_creds' => '{}',
            'have_shop' => 1,
            'findType' => 0,
            'reset_pwd' => 0,
            'user_login' => 0,
            'freelancer_login' => 0,
            'user_verify_with' => 0,
            'search_radius' => 50.0,
            'country_modal' => '[]',
            'default_country_code' => '+91',
            'social' => '[]',
            'app_color' => '#6200EE',
            'app_status' => 1,
            'status' => 1,
            'allowDistance' => 100.0, // 100 km radius
            'searchResultKind' => 0,  // km
        ]);
    }
}
