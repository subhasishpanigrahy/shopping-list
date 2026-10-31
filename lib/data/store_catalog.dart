import 'package:flutter/material.dart';

import '../models/product_category.dart';
import '../models/store_info.dart';

class StoreRelevanceResult {
  final List<StoreInfo> relevantStores;
  final List<StoreInfo> otherStores;

  const StoreRelevanceResult({
    required this.relevantStores,
    required this.otherStores,
  });

  List<StoreInfo> get allOrdered => [...relevantStores, ...otherStores];
}

class StoreCatalog {
  static const List<StoreInfo> allStores = [
    // --- UNIVERSAL POWERHOUSE STORES ---
    StoreInfo(
      id: 'amazon',
      name: 'Amazon',
      category: ProductCategory.general,
      webSearchUrlTemplate: 'https://www.amazon.in/s?k={query}',
      deepLinkScheme: 'com.amazon.mobile.shopping.web://amazon.in/s?k={query}',
      packageName: 'in.amazon.mShop.android.shopping',
      logoUrl: 'https://unavatar.io/amazon.com',
      brandColor: Color(0xFFFF9900),
      badgeText: 'Prime & Deals',
      tagline: 'World\'s largest selection & fast delivery',
    ),
    StoreInfo(
      id: 'flipkart',
      name: 'Flipkart',
      category: ProductCategory.general,
      webSearchUrlTemplate: 'https://www.flipkart.com/search?q={query}',
      deepLinkScheme: 'flipkart://search?q={query}',
      packageName: 'com.flipkart.android',
      logoUrl: 'https://unavatar.io/flipkart.com',
      brandColor: Color(0xFF2874F0),
      badgeText: 'Top Indian Marketplace',
      tagline: 'Explore India\'s premier online mega-store',
    ),
    StoreInfo(
      id: 'meesho',
      name: 'Meesho',
      category: ProductCategory.general,
      webSearchUrlTemplate: 'https://www.meesho.com/search?q={query}',
      deepLinkScheme: 'supply://open',
      packageName: 'com.meesho.supply',
      logoUrl: 'https://unavatar.io/meesho.com',
      brandColor: Color(0xFFF43397),
      badgeText: 'Wholesale & Value Deals',
      tagline: 'Lowest prices on fashion, home & daily essentials',
    ),
    StoreInfo(
      id: 'google_shopping',
      name: 'Google Shopping',
      category: ProductCategory.general,
      webSearchUrlTemplate: 'https://www.google.com/search?tbm=shop&q={query}',
      logoUrl: 'https://unavatar.io/google.com',
      brandColor: Color(0xFF4285F4),
      badgeText: 'Universal Price Compare',
      tagline: 'Compare prices across thousands of retailers',
    ),
    StoreInfo(
      id: 'ebay',
      name: 'eBay',
      category: ProductCategory.general,
      webSearchUrlTemplate: 'https://www.ebay.com/sch/i.html?_nkw={query}',
      deepLinkScheme: 'ebay://item/search?q={query}',
      packageName: 'com.ebay.mobile',
      logoUrl: 'https://unavatar.io/ebay.com',
      brandColor: Color(0xFFE53238),
      badgeText: 'Global Marketplace',
      tagline: 'New, refurbished & rare collectibles',
    ),

    // --- SNEAKERS & FASHION ---
    StoreInfo(
      id: 'nike_official',
      name: 'Nike Official',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://www.nike.com/in/w?q={query}',
      deepLinkScheme: 'nike://search?q={query}',
      packageName: 'com.nike.omega',
      logoUrl: 'https://unavatar.io/nike.com',
      brandColor: Color(0xFFFFFFFF),
      isVerifiedOfficial: true,
      associatedBrands: [
        'nike',
        'jordan',
        'air max',
        'dunk',
        'blazer',
        'air force',
        'snkrs',
      ],
      badgeText: 'Official Brand Store',
      tagline: 'Authentic drops, SNKRS releases & custom gear',
    ),
    StoreInfo(
      id: 'adidas_official',
      name: 'Adidas Official',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://www.adidas.co.in/search?q={query}',
      deepLinkScheme: 'adidas://search?q={query}',
      packageName: 'com.adidas.app',
      logoUrl: 'https://unavatar.io/adidas.com',
      brandColor: Color(0xFFFFFFFF),
      isVerifiedOfficial: true,
      associatedBrands: [
        'adidas',
        'yeezy',
        'ultraboost',
        'samba',
        'gazelle',
        'stan smith',
        'predator',
      ],
      badgeText: 'Official Brand Store',
      tagline: 'Authentic 3-Stripes Originals & Boost performance',
    ),
    StoreInfo(
      id: 'puma_official',
      name: 'Puma Official',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://in.puma.com/in/en/search?q={query}',
      deepLinkScheme: 'puma://search?q={query}',
      packageName: 'com.puma.omni.android',
      logoUrl: 'https://unavatar.io/puma.com',
      brandColor: Color(0xFF00E1D9),
      isVerifiedOfficial: true,
      associatedBrands: ['puma', 'nitro', 'suede'],
      badgeText: 'Official Brand Store',
      tagline: 'Forever Faster athletic sneakers & motorsport apparel',
    ),
    StoreInfo(
      id: 'myntra',
      name: 'Myntra',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://www.myntra.com/{query}',
      deepLinkScheme: 'myntra://myntra.com/{query}',
      packageName: 'com.myntra.android',
      logoUrl: 'https://unavatar.io/myntra.com',
      brandColor: Color(0xFFFF3F6C),
      badgeText: 'India\'s #1 Fashion Store',
      tagline: 'Curated apparel, shoes, luxury & accessories',
    ),
    StoreInfo(
      id: 'ajio',
      name: 'Ajio Luxe & Trends',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://www.ajio.com/search/?text={query}',
      deepLinkScheme: 'https://www.ajio.com/search/?text={query}',
      packageName: 'com.ril.ajio',
      logoUrl: 'https://unavatar.io/ajio.com',
      brandColor: Color(0xFF2C4152),
      badgeText: 'Handpicked Trends',
      tagline: 'Reliance fashion portal with exclusive global labels',
    ),
    StoreInfo(
      id: 'tatacliq',
      name: 'Tata CLiQ & Luxury',
      category: ProductCategory.fashion,
      webSearchUrlTemplate:
          'https://www.tatacliq.com/search/?searchCategory=all&text={query}',
      deepLinkScheme: 'tatacliq://search?text={query}',
      packageName: 'com.tul.tatacliq',
      logoUrl: 'https://unavatar.io/tatacliq.com',
      brandColor: Color(0xFFD61F5B),
      badgeText: 'Certified Authentic',
      tagline: 'Luxury, apparel & premium electronics by Tata',
    ),
    StoreInfo(
      id: 'zara',
      name: 'Zara',
      category: ProductCategory.fashion,
      webSearchUrlTemplate:
          'https://www.zara.com/in/en/search?searchTerm={query}',
      deepLinkScheme: 'zara://search?term={query}',
      packageName: 'com.inditex.zara',
      logoUrl: 'https://unavatar.io/zara.com',
      brandColor: Color(0xFFFFFFFF),
      isVerifiedOfficial: true,
      associatedBrands: ['zara'],
      badgeText: 'Official Brand Store',
      tagline: 'Latest runway fashion & Spanish minimalism',
    ),
    StoreInfo(
      id: 'hm',
      name: 'H&M Official',
      category: ProductCategory.fashion,
      webSearchUrlTemplate:
          'https://www2.hm.com/en_in/search-results.html?q={query}',
      deepLinkScheme: 'hm://search?q={query}',
      packageName: 'com.hm.goe',
      logoUrl: 'https://unavatar.io/hm.com',
      brandColor: Color(0xFFE50010),
      isVerifiedOfficial: true,
      associatedBrands: ['h&m', 'hm'],
      badgeText: 'Official Brand Store',
      tagline: 'Modern wardrobe essentials & seasonal collections',
    ),
    StoreInfo(
      id: 'uniqlo',
      name: 'Uniqlo Official',
      category: ProductCategory.fashion,
      webSearchUrlTemplate: 'https://www.uniqlo.com/in/en/search/?q={query}',
      packageName: 'com.uniqlo.in.catalogue',
      logoUrl: 'https://unavatar.io/uniqlo.com',
      brandColor: Color(0xFFFF0000),
      isVerifiedOfficial: true,
      associatedBrands: ['uniqlo', 'airism', 'heattech'],
      badgeText: 'Official Brand Store',
      tagline: 'LifeWear: AIRism, HeatTech & timeless casuals',
    ),

    // --- ELECTRONICS & TECH ---
    StoreInfo(
      id: 'apple_store',
      name: 'Apple Store',
      category: ProductCategory.electronics,
      webSearchUrlTemplate:
          'https://www.apple.com/in/search/{query}?src=globalnav',
      deepLinkScheme: 'applestore://search?q={query}',
      logoUrl: 'https://unavatar.io/apple.com',
      brandColor: Color(0xFFA2AAAD),
      isVerifiedOfficial: true,
      associatedBrands: [
        'apple',
        'macbook',
        'iphone',
        'ipad',
        'airpods',
        'apple watch',
        'imac',
        'mac mini',
        'm1',
        'm2',
        'm3',
        'm4',
      ],
      badgeText: 'Official Brand Store',
      tagline: 'Buy direct with laser engraving & official warranty',
    ),
    StoreInfo(
      id: 'croma',
      name: 'Croma Electronics',
      category: ProductCategory.electronics,
      webSearchUrlTemplate:
          'https://www.croma.com/searchB?q={query}%3Arelevance',
      deepLinkScheme: 'croma://search?q={query}',
      packageName: 'com.croma.android',
      logoUrl: 'https://unavatar.io/croma.com',
      brandColor: Color(0xFF00E9BF),
      badgeText: 'Tata Electronics Retail',
      tagline: 'Laptops, TVs, smartphones with express store pickup',
    ),
    StoreInfo(
      id: 'reliance_digital',
      name: 'Reliance Digital',
      category: ProductCategory.electronics,
      webSearchUrlTemplate: 'https://www.reliancedigital.in/search?q={query}',
      deepLinkScheme: 'reliancedigital://search?q={query}',
      packageName: 'com.reliancedigital.app',
      logoUrl: 'https://unavatar.io/reliancedigital.in',
      brandColor: Color(0xFFE42529),
      badgeText: 'Trusted Tech Retailer',
      tagline: 'Widest range of personal electronics & home appliances',
    ),
    StoreInfo(
      id: 'samsung_shop',
      name: 'Samsung Shop',
      category: ProductCategory.electronics,
      webSearchUrlTemplate:
          'https://www.samsung.com/in/search/?searchvalue={query}',
      deepLinkScheme: 'samsungestore://open',
      packageName: 'com.samsung.ecomm.global.in',
      logoUrl: 'https://unavatar.io/samsung.com',
      brandColor: Color(0xFF1428A0),
      isVerifiedOfficial: true,
      associatedBrands: ['samsung', 'galaxy', 'z fold', 'z flip', 'exynos'],
      badgeText: 'Official Brand Store',
      tagline: 'Galaxy smartphones, OLED TVs & SmartThings',
    ),
    StoreInfo(
      id: 'sony_center',
      name: 'Sony Official SC',
      category: ProductCategory.electronics,
      webSearchUrlTemplate: 'https://shopatsc.com/search?q={query}',
      logoUrl: 'https://unavatar.io/sony.com',
      brandColor: Color(0xFF000000),
      isVerifiedOfficial: true,
      associatedBrands: [
        'sony',
        'playstation',
        'ps5',
        'bravia',
        'dualsense',
        'wh-1000xm',
      ],
      badgeText: 'Official Sony Portal',
      tagline: 'PlayStation consoles, Alpha cameras & ANC headphones',
    ),
    StoreInfo(
      id: 'oneplus_store',
      name: 'OnePlus Store',
      category: ProductCategory.electronics,
      webSearchUrlTemplate: 'https://www.oneplus.in/search?keyword={query}',
      packageName: 'net.oneplus.mall',
      logoUrl: 'https://unavatar.io/oneplus.com',
      brandColor: Color(0xFFEB0028),
      isVerifiedOfficial: true,
      associatedBrands: ['oneplus', 'nord'],
      badgeText: 'Official Brand Store',
      tagline: 'Never Settle smartphones, tablets & audio',
    ),

    // --- QUICK COMMERCE & GROCERIES ---
    StoreInfo(
      id: 'blinkit',
      name: 'Blinkit',
      category: ProductCategory.groceries,
      webSearchUrlTemplate: 'https://blinkit.com/s?q={query}',
      deepLinkScheme: 'blinkit://search?q={query}',
      packageName: 'com.grofers.customerapp',
      logoUrl: 'https://unavatar.io/blinkit.com',
      brandColor: Color(0xFFF8CB46),
      badgeText: '10-Min Delivery',
      tagline: 'Everything delivered in minutes right to your doorstep',
    ),
    StoreInfo(
      id: 'zepto',
      name: 'Zepto',
      category: ProductCategory.groceries,
      webSearchUrlTemplate: 'https://www.zeptonow.com/search?query={query}',
      deepLinkScheme: 'zepto://zeptonow.com/app',
      packageName: 'com.zeptoconsumerapp',
      logoUrl: 'https://unavatar.io/zeptonow.com',
      brandColor: Color(0xFF7B2CBF),
      badgeText: 'Instant Grocery',
      tagline: 'Fresh veggies, dairy, snacks & personal care lightning-fast',
    ),
    StoreInfo(
      id: 'swiggy_instamart',
      name: 'Swiggy Instamart',
      category: ProductCategory.groceries,
      webSearchUrlTemplate: 'https://www.swiggy.com/instamart/search?custom_back=true&query={query}',
      deepLinkScheme: 'swiggy://instamart/search?query={query}',
      packageName: 'in.swiggy.android',
      logoUrl: 'https://unavatar.io/swiggy.com',
      brandColor: Color(0xFFFC8019),
      badgeText: 'Swiggy Network',
      tagline: 'Instant staples, quick bites and household necessities',
    ),
    StoreInfo(
      id: 'bigbasket',
      name: 'BigBasket',
      category: ProductCategory.groceries,
      webSearchUrlTemplate: 'https://www.bigbasket.com/ps/?q={query}',
      deepLinkScheme: 'bigbasket://open',
      packageName: 'com.bigbasket.mobileapp',
      logoUrl: 'https://unavatar.io/bigbasket.com',
      brandColor: Color(0xFF84C225),
      badgeText: 'Tata Supermarket',
      tagline: 'India\'s comprehensive farm-fresh & pantry supermarket',
    ),
    StoreInfo(
      id: 'jiomart',
      name: 'JioMart',
      category: ProductCategory.groceries,
      webSearchUrlTemplate: 'https://www.jiomart.com/search/{query}',
      deepLinkScheme: 'jiomart://search?q={query}',
      packageName: 'com.jpl.jiomart',
      logoUrl: 'https://unavatar.io/jiomart.com',
      brandColor: Color(0xFF0078AD),
      badgeText: 'Everyday Low Prices',
      tagline: 'Groceries, staples and electronics from Reliance Retail',
    ),

    // --- BEAUTY & SKINCARE ---
    StoreInfo(
      id: 'nykaa',
      name: 'Nykaa',
      category: ProductCategory.beauty,
      webSearchUrlTemplate: 'https://www.nykaa.com/search/result/?q={query}',
      deepLinkScheme: 'nykaa://search?q={query}',
      packageName: 'com.fsn.nykaa',
      logoUrl: 'https://unavatar.io/nykaa.com',
      brandColor: Color(0xFFFC2779),
      badgeText: 'Beauty Authority',
      tagline: '100% genuine cosmetics, skincare & luxury wellness',
    ),
    StoreInfo(
      id: 'tira',
      name: 'Tira Beauty',
      category: ProductCategory.beauty,
      webSearchUrlTemplate: 'https://www.tirabeauty.com/search?q={query}',
      deepLinkScheme: 'tirabeauty://search?q={query}',
      packageName: 'com.ril.tira',
      logoUrl: 'https://unavatar.io/tirabeauty.com',
      brandColor: Color(0xFF0F172A),
      badgeText: 'Prestige Beauty',
      tagline: 'Curated international luxury skincare & fragrance',
    ),
    StoreInfo(
      id: 'purplle',
      name: 'Purplle',
      category: ProductCategory.beauty,
      webSearchUrlTemplate: 'https://www.purplle.com/search?q={query}',
      deepLinkScheme: 'purplle://search?q={query}',
      packageName: 'com.manash.purplle',
      logoUrl: 'https://unavatar.io/purplle.com',
      brandColor: Color(0xFF8B008B),
      badgeText: 'Budget Skincare',
      tagline: 'Affordable beauty essentials, makeup & haircare',
    ),

    // --- HOME & LIVING ---
    StoreInfo(
      id: 'ikea',
      name: 'IKEA Official',
      category: ProductCategory.home,
      webSearchUrlTemplate: 'https://www.ikea.com/in/en/search/?q={query}',
      deepLinkScheme: 'ikea://search?q={query}',
      packageName: 'com.ikea.kompis.app',
      logoUrl: 'https://unavatar.io/ikea.com',
      brandColor: Color(0xFF0058A3),
      isVerifiedOfficial: true,
      associatedBrands: ['ikea'],
      badgeText: 'Official Store',
      tagline: 'Scandinavian furniture, smart organization & decor',
    ),
    StoreInfo(
      id: 'urban_ladder',
      name: 'Urban Ladder',
      category: ProductCategory.home,
      webSearchUrlTemplate:
          'https://www.urbanladder.com/products/search?keywords={query}',
      logoUrl: 'https://unavatar.io/urbanladder.com',
      brandColor: Color(0xFFF16521),
      badgeText: 'Designer Furniture',
      tagline: 'Contemporary solid wood furnishings & accents',
    ),
    StoreInfo(
      id: 'pepperfry',
      name: 'Pepperfry',
      category: ProductCategory.home,
      webSearchUrlTemplate:
          'https://www.pepperfry.com/site_product/search?q={query}',
      packageName: 'com.pepperfry.app',
      logoUrl: 'https://unavatar.io/pepperfry.com',
      brandColor: Color(0xFFE25B26),
      badgeText: 'Home Megastore',
      tagline: 'Furniture, kitchen essentials and decor catalogue',
    ),
  ];

  static bool _containsAny(String text, List<String> keywords) {
    final words = text.toLowerCase().split(RegExp(r'[^\w]+')).where((w) => w.isNotEmpty).toSet();
    for (final k in keywords) {
      final kLower = k.toLowerCase();
      if (kLower.contains(' ') || kLower.contains('-')) {
        if (text.toLowerCase().contains(kLower)) return true;
      } else {
        if (words.contains(kLower)) return true;
      }
    }
    return false;
  }

  /// Calculates a relevance score for a store against a query, category, and brand.
  static int _calculateRelevanceScore({
    required StoreInfo store,
    required String query,
    required ProductCategory category,
    String? detectedBrand,
  }) {
    final cleanQuery = query.toLowerCase().trim();
    final brand = detectedBrand?.toLowerCase().trim();

    // 1. Direct Specific Brand Match (+1000)
    final matchesStoreBrand = store.associatedBrands.isNotEmpty &&
        store.associatedBrands.any((b) {
          final bLower = b.toLowerCase();
          return cleanQuery.contains(bLower) ||
              (brand != null && (brand.contains(bLower) || bLower.contains(brand)));
        });

    if (matchesStoreBrand) {
      return 1000;
    }

    // 2. Official Single-Brand Store Exclusion
    // Single-brand official portals (Nike, Apple, Sony, IKEA, etc.) ONLY sell their own products.
    // If the query did not match their brand, they have no search results for this item.
    if (store.isVerifiedOfficial) {
      return -100;
    }

    // 3. Indian Ethnic Wear Specialty (Saree, Kurta, Kurti, Lehenga, Dupatta, Silk, etc.)
    final isEthnicWear = _containsAny(cleanQuery, [
      'saree', 'sari', 'kurta', 'kurti', 'lehenga', 'dupatta', 'anarkali', 'ethnic',
      'salwar', 'sherwani', 'chikan', 'banarasi', 'kanjivaram', 'chanderi', 'bandhani', 'paithani'
    ]);

    if (isEthnicWear) {
      if (store.id == 'meesho') return 250; // Meesho is India's premier ethnic/saree marketplace
      if (store.id == 'myntra') return 220;
      if (store.id == 'ajio') return 210;
      if (store.id == 'tatacliq') return 190;
      if (store.id == 'flipkart') return 180;
      if (store.id == 'amazon') return 170;
      if (store.id == 'google_shopping') return 100;
      // Western/casual brands & other categories don't sell sarees
      return -100;
    }

    // 4. Sneakers & Athletic Shoes
    final isSneakerOrSports = _containsAny(cleanQuery, [
      'sneaker', 'sneakers', 'running shoes', 'cleats', 'basketball', 'jogging', 'trainers', 'spikes'
    ]);
    if (isSneakerOrSports) {
      if (store.id == 'nike_official' || store.id == 'adidas_official' || store.id == 'puma_official') {
        return 300;
      }
      if (store.id == 'myntra' || store.id == 'ajio' || store.id == 'flipkart' || store.id == 'amazon') {
        return 200;
      }
    }

    // 5. Tech & Gadgets (Laptops, Phones, Consoles, Audio, Components)
    final isTechProduct = category == ProductCategory.electronics ||
        _containsAny(cleanQuery, [
          'macbook', 'iphone', 'ipad', 'laptop', 'smartphone', 'phone', 'ps5', 'playstation',
          'headphone', 'headphones', 'earbud', 'earbuds', 'tv', 'oled', 'qled', 'monitor',
          'gpu', 'camera', 'smartwatch', 'speaker', 'charger', 'tablet'
        ]);

    if (isTechProduct) {
      if (store.id == 'croma' || store.id == 'reliance_digital') return 250;
      if (store.id == 'amazon' || store.id == 'flipkart') return 220;
      if (store.id == 'tatacliq') return 180;
      if (store.id == 'google_shopping') return 150;
      if (store.id == 'ebay') return 140;
      // Grocery, beauty, ethnic wear stores do NOT sell laptops or phones
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'bigbasket' ||
          store.id == 'nykaa' || store.id == 'purplle' || store.id == 'meesho' || store.id == 'ikea') {
        return -100;
      }
    }

    // 6. Oral Hygiene, Grooming & Daily Personal Care
    final isPersonalCare = _containsAny(cleanQuery, [
      'tongue cleaner', 'toothbrush', 'toothpaste', 'mouthwash', 'dental floss', 'floss',
      'shaver', 'razor', 'trimmer', 'comb', 'hair brush', 'soap', 'body wash', 'sanitizer',
      'shampoo', 'conditioner', 'deodorant', 'deo', 'perfume', 'talc', 'face wash'
    ]);

    if (isPersonalCare) {
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'swiggy_instamart') return 250;
      if (store.id == 'bigbasket' || store.id == 'jiomart') return 240;
      if (store.id == 'nykaa' || store.id == 'tira' || store.id == 'purplle') return 230;
      if (store.id == 'amazon' || store.id == 'flipkart') return 220;
      if (store.id == 'meesho') return 210;
      if (store.id == 'myntra' || store.id == 'ajio') return 200;
      if (store.id == 'google_shopping') return 150;
      if (store.isVerifiedOfficial) return -100;
    }

    // 7. Household Daily Essentials, Pest Control, Pooja, Cleaning & Baby Care
    final isHouseholdOrPest = _containsAny(cleanQuery, [
      'mosquito', 'mosquito stick', 'mosquito coil', 'mosquito repellent', 'mosquito bat',
      'repellent', 'good knight', 'goodknight', 'all out', 'allout', 'hit spray', 'hit',
      'baygon', 'mortein', 'coil', 'agarbatti', 'incense', 'dhoop', 'camphor', 'kapoor',
      'pooja', 'puja', 'diya', 'cotton wicks', 'matchbox', 'matches', 'battery', 'batteries',
      'duracell', 'broom', 'mop', 'wiper', 'scrubber', 'dustbin', 'garbage bag', 'trash bag',
      'foil', 'aluminium foil', 'aluminum foil', 'cling wrap', 'harpic', 'lizol', 'detergent',
      'dishwash', 'odonil', 'air freshener', 'rat kill', 'cockroach', 'odomos', 'sanitary',
      'whisper', 'stayfree', 'diaper', 'diapers', 'pampers', 'wipe', 'wipes', 'tissue',
      'dettol', 'savlon', 'bandaid', 'vicks', 'surf excel', 'ariel', 'vim', 'pril', 'sponge'
    ]);

    if (isHouseholdOrPest) {
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'swiggy_instamart') return 250;
      if (store.id == 'bigbasket' || store.id == 'jiomart') return 230;
      if (store.id == 'amazon' || store.id == 'flipkart') return 220;
      if (store.id == 'meesho') return 200;
      if (store.id == 'google_shopping') return 120;
      return -100;
    }

    // 8. Groceries & Quick Commerce (Daily pantry, food, produce, dairy)
    final isGroceryProduct = category == ProductCategory.groceries ||
        _containsAny(cleanQuery, [
          'milk', 'bread', 'butter', 'cheese', 'egg', 'eggs', 'vegetable', 'fruit', 'fruits',
          'onion', 'potato', 'tomato', 'snack', 'chips', 'biscuit', 'curd', 'paneer', 'dal',
          'rice', 'atta', 'oil', 'masala', 'tea', 'coffee', 'sugar', 'salt', 'maggi',
          'noodle', 'noodles', 'pasta', 'ketchup', 'sauce', 'honey', 'jam', 'cereal', 'oats'
        ]);

    if (isGroceryProduct) {
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'swiggy_instamart') return 250;
      if (store.id == 'bigbasket' || store.id == 'jiomart') return 220;
      if (store.id == 'amazon' || store.id == 'flipkart') return 180;
      if (store.id == 'meesho') return 140;
      if (store.id == 'google_shopping') return 100;
      return -100;
    }

    // 9. Beauty & Personal Care (Skincare, makeup, cosmetics, fragrance)
    final isBeautyProduct = category == ProductCategory.beauty ||
        _containsAny(cleanQuery, [
          'serum', 'moisturizer', 'sunscreen', 'lipstick', 'makeup', 'cleanser', 'perfume',
          'shampoo', 'conditioner', 'mascara', 'foundation', 'skincare', 'cosmetics', 'lotion',
          'face wash', 'body wash'
        ]);

    if (isBeautyProduct) {
      if (store.id == 'nykaa' || store.id == 'tira' || store.id == 'purplle') return 250;
      if (store.id == 'myntra' || store.id == 'ajio') return 210;
      if (store.id == 'amazon' || store.id == 'flipkart') return 200;
      if (store.id == 'meesho') return 190;
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'swiggy_instamart' || store.id == 'bigbasket') return 180;
      if (store.id == 'google_shopping') return 100;
      return -100;
    }

    // 10. Home & Living (Furniture, decor, organization)
    final isHomeProduct = category == ProductCategory.home ||
        _containsAny(cleanQuery, [
          'sofa', 'couch', 'chair', 'table', 'desk', 'bed', 'mattress', 'wardrobe', 'curtain',
          'curtains', 'lamp', 'decor', 'bookshelf', 'cushion', 'rug', 'carpet', 'furniture'
        ]);

    if (isHomeProduct) {
      if (store.id == 'ikea' || store.id == 'urban_ladder' || store.id == 'pepperfry') return 250;
      if (store.id == 'amazon' || store.id == 'flipkart') return 200;
      if (store.id == 'meesho') return 160;
      if (store.id == 'google_shopping') return 100;
      return -100;
    }

    // 11. Standard Category Multi-Brand Store Match (+100)
    if (category != ProductCategory.all && category != ProductCategory.general && store.category == category) {
      return 100;
    }

    // 12. Universal General Search Fallback (when no specialized category is detected)
    if (category == ProductCategory.general) {
      if (store.id == 'amazon' || store.id == 'flipkart') return 160;
      if (store.id == 'meesho') return 140;
      // Quick commerce megastores carry everyday general convenience goods
      if (store.id == 'blinkit' || store.id == 'zepto' || store.id == 'swiggy_instamart') return 130;
      if (store.id == 'bigbasket' || store.id == 'jiomart') return 120;
      if (store.id == 'google_shopping') return 100;
      if (store.id == 'ebay') return 70;
      if (store.id == 'tatacliq') return 60;
      if (store.id == 'myntra' || store.id == 'ajio') return 55;
      return -50;
    }

    // 13. Universal Powerhouses in any other category
    if (store.category == ProductCategory.general) {
      if (store.id == 'amazon' || store.id == 'flipkart') return 140;
      if (store.id == 'meesho') return 130;
      if (store.id == 'google_shopping') return 100;
      if (store.id == 'ebay') return 70;
    }

    // Default low score for non-matching categories
    return -50;
  }

  /// Separates and sorts stores into Relevant (shown first) and Other (shown towards the end)
  static StoreRelevanceResult getPrioritizedStores({
    required String query,
    required ProductCategory category,
    String? detectedBrand,
    List<StoreInfo> customStores = const [],
  }) {
    final cleanQuery = query.toLowerCase().trim();
    final normalizedBrand = detectedBrand?.toLowerCase().trim();

    final List<StoreInfo> candidatePool = [
      ...customStores,
      ...allStores,
    ];

    final List<MapEntry<StoreInfo, int>> scored = [];

    for (final store in candidatePool) {
      final score = _calculateRelevanceScore(
        store: store,
        query: cleanQuery,
        category: category,
        detectedBrand: normalizedBrand,
      );
      scored.add(MapEntry(store, score));
    }

    // Sort by descending score
    scored.sort((a, b) => b.value.compareTo(a.value));

    final relevant = scored.where((e) => e.value > 0).map((e) => e.key).toList();
    final others = scored.where((e) => e.value <= 0).map((e) => e.key).toList();

    return StoreRelevanceResult(
      relevantStores: relevant,
      otherStores: others,
    );
  }

  /// Returns prioritized stores matching a shopping item title, category, and brand.
  static List<StoreInfo> getStoresForItem({
    required ProductCategory category,
    String? detectedBrand,
    String? query,
    List<StoreInfo> customStores = const [],
  }) {
    if (query != null && query.trim().isNotEmpty) {
      final res = getPrioritizedStores(
        query: query,
        category: category,
        detectedBrand: detectedBrand,
        customStores: customStores,
      );
      return res.allOrdered;
    }

    final List<StoreInfo> brandMatches = [];
    final List<StoreInfo> customCategoryMatches = [];
    final List<StoreInfo> categoryMatches = [];
    final List<StoreInfo> generalMatches = [];
    final List<StoreInfo> otherMatches = [];

    // Prioritize user-added custom stores matching the category
    for (final customStore in customStores) {
      if (category == ProductCategory.all ||
          customStore.category == ProductCategory.general ||
          customStore.category == category) {
        customCategoryMatches.add(customStore);
      } else {
        otherMatches.add(customStore);
      }
    }

    final normalizedBrand = detectedBrand?.toLowerCase().trim();

    for (final store in allStores) {
      // 1. Direct official brand match
      bool isBrandStore = false;
      if (normalizedBrand != null && normalizedBrand.isNotEmpty) {
        if (store.associatedBrands.any(
          (b) =>
              normalizedBrand.contains(b.toLowerCase()) ||
              b.toLowerCase().contains(normalizedBrand),
        )) {
          brandMatches.add(store);
          isBrandStore = true;
        }
      }

      if (isBrandStore) continue;

      // 2. Category match
      if (category != ProductCategory.all &&
          category != ProductCategory.general &&
          store.category == category) {
        categoryMatches.add(store);
        continue;
      }

      // 3. General marketplace match (Amazon, Flipkart, Google Shopping)
      if (store.category == ProductCategory.general) {
        generalMatches.add(store);
        continue;
      }

      otherMatches.add(store);
    }

    // Build the sorted list: Official brand store first -> Custom stores -> Category stores -> General marketplaces -> Others
    return [
      ...brandMatches,
      ...customCategoryMatches,
      ...categoryMatches,
      ...generalMatches,
      ...otherMatches,
    ];
  }
}
