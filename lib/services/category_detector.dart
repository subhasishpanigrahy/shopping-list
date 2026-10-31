import '../models/product_category.dart';

class DetectionResult {
  final ProductCategory category;
  final String? brand;

  const DetectionResult({required this.category, this.brand});
}

class CategoryDetector {
  static const Map<String, String> _knownBrands = {
    'nike': 'Nike',
    'jordan': 'Nike Jordan',
    'air max': 'Nike',
    'snkrs': 'Nike',
    'adidas': 'Adidas',
    'yeezy': 'Adidas',
    'ultraboost': 'Adidas',
    'samba': 'Adidas',
    'puma': 'Puma',
    'zara': 'Zara',
    'h&m': 'H&M',
    'hm': 'H&M',
    'uniqlo': 'Uniqlo',
    'apple': 'Apple',
    'macbook': 'Apple',
    'iphone': 'Apple',
    'ipad': 'Apple',
    'airpods': 'Apple',
    'imac': 'Apple',
    'samsung': 'Samsung',
    'galaxy': 'Samsung',
    'sony': 'Sony',
    'playstation': 'Sony',
    'ps5': 'Sony',
    'oneplus': 'OnePlus',
    'google': 'Google',
    'pixel': 'Google',
    'dell': 'Dell',
    'hp': 'HP',
    'lenovo': 'Lenovo',
    'asus': 'Asus',
    'bose': 'Bose',
    'jbl': 'JBL',
    'boat': 'boAt',
    'noise': 'Noise',
    'nykaa': 'Nykaa',
    'loreal': "L'Oreal",
    "l'oreal": "L'Oreal",
    'maybelline': 'Maybelline',
    'cerave': 'CeraVe',
    'cetaphil': 'Cetaphil',
    'minimalist': 'Minimalist',
    'the ordinary': 'The Ordinary',
    'ordinary': 'The Ordinary',
    'ikea': 'IKEA',
    'amul': 'Amul',
    'nestle': 'Nestle',
    'britannia': 'Britannia',
    'tata': 'Tata',
    'casio': 'Casio',
    'fossil': 'Fossil',
    'titan': 'Titan',
    'ray-ban': 'Ray-Ban',
    'rayban': 'Ray-Ban',
  };

  static const List<String> _fashionKeywords = [
    'shoe',
    'shoes',
    'sneaker',
    'sneakers',
    'air max',
    'jordan',
    'dunk',
    'samba',
    'gazelle',
    'ultraboost',
    'yeezy',
    'runner',
    'boots',
    'sandals',
    'crocs',
    'slides',
    'heels',
    'loafers',
    'shirt',
    't-shirt',
    'tshirt',
    'tee',
    'polo',
    'jeans',
    'denim',
    'hoodie',
    'jacket',
    'coat',
    'sweater',
    'sweatshirt',
    'dress',
    'skirt',
    'top',
    'trousers',
    'pants',
    'shorts',
    'suit',
    'blazer',
    'watch',
    'sunglasses',
    'handbag',
    'bag',
    'purse',
    'wallet',
    'belt',
    'cap',
    'hat',
    'scarf',
    'socks',
    'saree',
    'kurta',
    'lehenga',
    'swimsuit',
    'activewear',
    'gym wear',
    'tracksuit',
    'joggers',
    'zara',
    'h&m',
    'uniqlo',
  ];

  static const List<String> _electronicsKeywords = [
    'macbook',
    'iphone',
    'ipad',
    'airpods',
    'laptop',
    'notebook',
    'pc',
    'desktop',
    'phone',
    'smartphone',
    'mobile',
    'galaxy',
    'android',
    'tablet',
    'tv',
    'television',
    'oled',
    'qled',
    'monitor',
    'display',
    'screen',
    'gpu',
    'graphics card',
    'cpu',
    'processor',
    'ram',
    'ssd',
    'hard drive',
    'headphones',
    'headset',
    'earbuds',
    'earphones',
    'airpod',
    'charger',
    'adapter',
    'cable',
    'power bank',
    'camera',
    'lens',
    'dslr',
    'gopro',
    'drone',
    'ps5',
    'playstation',
    'xbox',
    'nintendo',
    'switch',
    'console',
    'controller',
    'smartwatch',
    'apple watch',
    'fitness tracker',
    'smart band',
    'speaker',
    'soundbar',
    'bluetooth',
    'mouse',
    'keyboard',
    'printer',
    'scanner',
    'router',
    'wifi',
    'microphone',
    'webcam',
    'projector',
  ];

  static const List<String> _groceriesKeywords = [
    'milk',
    'butter',
    'almond',
    'almonds',
    'cashew',
    'walnut',
    'peanut',
    'bread',
    'cheese',
    'egg',
    'eggs',
    'coffee',
    'tea',
    'matcha',
    'oat',
    'oats',
    'cereal',
    'muesli',
    'granola',
    'rice',
    'oil',
    'olive oil',
    'biscuit',
    'biscuits',
    'cookie',
    'cookies',
    'snack',
    'snacks',
    'chocolate',
    'fruit',
    'fruits',
    'vegetable',
    'vegetables',
    'flour',
    'atta',
    'dal',
    'pulses',
    'sugar',
    'salt',
    'spice',
    'spices',
    'pepper',
    'curd',
    'yogurt',
    'paneer',
    'tofu',
    'pasta',
    'noodles',
    'maggi',
    'chips',
    'crisps',
    'sauce',
    'ketchup',
    'mayo',
    'juice',
    'water',
    'soda',
    'coke',
    'pepsi',
    'honey',
    'peanut butter',
    'jam',
    'nutella',
    'onion',
    'potato',
    'tomato',
    'banana',
    'apple fruit',
    'ginger',
    'garlic',
    'detergent',
    'dishwash',
    'cleaner',
    'toilet paper',
    'tissue',
    // Pest control & repellents
    'mosquito',
    'mosquito stick',
    'mosquito coil',
    'mosquito repellent',
    'mosquito bat',
    'mosquito net',
    'repellent',
    'good knight',
    'goodknight',
    'all out',
    'allout',
    'hit spray',
    'hit',
    'baygon',
    'mortein',
    'coil',
    'odomos',
    'cockroach',
    'rat kill',
    // Pooja & spiritual essentials
    'agarbatti',
    'incense',
    'incense sticks',
    'dhoop',
    'camphor',
    'kapoor',
    'pooja',
    'puja',
    'diya',
    'cotton wicks',
    'matchbox',
    'matches',
    // Household cleaning & trash supplies
    'broom',
    'mop',
    'wiper',
    'scrubber',
    'dustbin',
    'garbage bag',
    'trash bag',
    'foil',
    'aluminium foil',
    'aluminum foil',
    'cling wrap',
    'harpic',
    'lizol',
    'odonil',
    'air freshener',
    'vim',
    'surf excel',
    'ariel',
    'tide',
    'rin',
    'comfort',
    'pril',
    'sponge',
    // Household utilities & hardware
    'battery',
    'batteries',
    'duracell',
    'lighter',
    'safety pin',
    'fevikwik',
    // Personal hygiene, baby & OTC essentials
    'bandaid',
    'dettol',
    'savlon',
    'cotton',
    'vicks',
    'sanitary napkin',
    'pads',
    'whisper',
    'stayfree',
    'diaper',
    'diapers',
    'pampers',
    'wipes',
    'baby wipes',
    'condom',
    'ors',
    'eno',
  ];

  static const List<String> _beautyKeywords = [
    'serum',
    'moisturizer',
    'sunscreen',
    'spf',
    'lipstick',
    'lip gloss',
    'lip balm',
    'mascara',
    'eyeliner',
    'foundation',
    'concealer',
    'blush',
    'bronzer',
    'highlighter',
    'powder',
    'toner',
    'cleanser',
    'face wash',
    'face scrub',
    'face mask',
    'sheet mask',
    'perfume',
    'cologne',
    'fragrance',
    'eau de parfum',
    'hair oil',
    'conditioner',
    'hair mask',
    'body wash',
    'body scrub',
    'body lotion',
    'retinol',
    'niacinamide',
    'hyaluronic',
    'vitamin c',
    'salicylic',
    'exfoliator',
    'shaving cream',
    'aftershave',
    'nail polish',
    'makeup',
    'tongue cleaner',
    'toothbrush',
    'toothpaste',
    'mouthwash',
    'dental floss',
    'floss',
    'trimmer',
    'shaver',
    'comb',
    'soap',
  ];

  static const List<String> _homeKeywords = [
    'chair',
    'table',
    'desk',
    'sofa',
    'couch',
    'bed',
    'mattress',
    'pillow',
    'cushion',
    'bedsheet',
    'blanket',
    'comforter',
    'duvet',
    'curtain',
    'rug',
    'carpet',
    'mat',
    'lamp',
    'lighting',
    'light bulb',
    'chandelier',
    'mirror',
    'bookshelf',
    'shelf',
    'wardrobe',
    'cupboard',
    'cabinet',
    'drawer',
    'rack',
    'hanger',
    'organizer',
    'plate',
    'bowl',
    'mug',
    'cup',
    'glass',
    'fork',
    'spoon',
    'knife',
    'pan',
    'pot',
    'cookware',
    'skillet',
    'pressure cooker',
    'kettle',
    'toaster',
    'blender',
    'air fryer',
    'microwave',
    'oven',
    'towel',
    'vase',
    'clock',
    'plant pot',
  ];

  /// Detects category and brand from user input title
  static DetectionResult detect(String rawTitle) {
    final title = rawTitle.toLowerCase().trim();
    if (title.isEmpty) {
      return const DetectionResult(category: ProductCategory.general);
    }

    // 1. Detect Brand first
    String? detectedBrand;
    for (final entry in _knownBrands.entries) {
      final key = entry.key;
      // Word boundary or substring check
      final regex = RegExp('\\b${RegExp.escape(key)}\\b', caseSensitive: false);
      if (regex.hasMatch(title) || title.contains(key)) {
        // Special case: if word is 'apple', verify it's not fruit context
        if (key == 'apple') {
          if (title.contains('green apple') ||
              title.contains('red apple') ||
              title.contains('fresh apple') ||
              title.contains('kg') ||
              title.contains('fruit')) {
            continue;
          }
        }
        detectedBrand = entry.value;
        break;
      }
    }

    // 2. Score Categories
    final scores = <ProductCategory, int>{
      ProductCategory.fashion: 0,
      ProductCategory.electronics: 0,
      ProductCategory.groceries: 0,
      ProductCategory.beauty: 0,
      ProductCategory.home: 0,
    };

    final titleWords = title
        .toLowerCase()
        .split(RegExp(r'[^\w]+'))
        .where((w) => w.isNotEmpty)
        .toSet();

    void scoreList(List<String> keywords, ProductCategory cat, int weight) {
      for (final kw in keywords) {
        final matches = kw.contains(' ') || kw.contains('-')
            ? title.contains(kw)
            : titleWords.contains(kw);
        if (matches) {
          // Specific multi-word keywords (e.g. 'tongue cleaner') carry higher affinity than generic single words
          final specificityBonus = kw.contains(' ') ? 2 : 0;
          scores[cat] = (scores[cat] ?? 0) + weight + specificityBonus;
        }
      }
    }

    scoreList(_fashionKeywords, ProductCategory.fashion, 2);
    scoreList(_electronicsKeywords, ProductCategory.electronics, 2);
    scoreList(_groceriesKeywords, ProductCategory.groceries, 2);
    scoreList(_beautyKeywords, ProductCategory.beauty, 2);
    scoreList(_homeKeywords, ProductCategory.home, 2);

    // Brand influence
    if (detectedBrand != null) {
      final b = detectedBrand.toLowerCase();
      if (b.contains('nike') ||
          b.contains('adidas') ||
          b.contains('puma') ||
          b.contains('zara') ||
          b.contains('h&m') ||
          b.contains('uniqlo')) {
        scores[ProductCategory.fashion] =
            (scores[ProductCategory.fashion] ?? 0) + 5;
      } else if (b.contains('apple') ||
          b.contains('samsung') ||
          b.contains('sony') ||
          b.contains('oneplus') ||
          b.contains('dell') ||
          b.contains('hp') ||
          b.contains('lenovo') ||
          b.contains('asus') ||
          b.contains('bose') ||
          b.contains('jbl')) {
        scores[ProductCategory.electronics] =
            (scores[ProductCategory.electronics] ?? 0) + 5;
      } else if (b.contains('amul') ||
          b.contains('nestle') ||
          b.contains('britannia')) {
        scores[ProductCategory.groceries] =
            (scores[ProductCategory.groceries] ?? 0) + 5;
      } else if (b.contains('nykaa') ||
          b.contains("l'oreal") ||
          b.contains('maybelline') ||
          b.contains('cerave') ||
          b.contains('cetaphil') ||
          b.contains('the ordinary')) {
        scores[ProductCategory.beauty] =
            (scores[ProductCategory.beauty] ?? 0) + 5;
      } else if (b.contains('ikea')) {
        scores[ProductCategory.home] = (scores[ProductCategory.home] ?? 0) + 5;
      }
    }

    // Pick category with highest score > 0
    ProductCategory winningCategory = ProductCategory.general;
    int maxScore = 0;

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        winningCategory = entry.key;
      }
    }

    return DetectionResult(category: winningCategory, brand: detectedBrand);
  }
}
