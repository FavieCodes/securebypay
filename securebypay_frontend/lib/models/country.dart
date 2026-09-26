
class Country {
  final String isoCode;
  final String name;
  final String dialCode;

  const Country({required this.isoCode, required this.name, required this.dialCode});


  String get flagEmoji {
    const base = 0x1F1E6; 
    final chars = isoCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(base + (c - 'A'.codeUnitAt(0))));
    return chars.join();
  }

  @override
  bool operator ==(Object other) => other is Country && other.isoCode == isoCode;

  @override
  int get hashCode => isoCode.hashCode;
}


const Country kDefaultCountry = Country(isoCode: 'NG', name: 'Nigeria', dialCode: '+234');

const List<Country> kCountries = [
  kDefaultCountry,
  Country(isoCode: 'US', name: 'United States', dialCode: '+1'),
  Country(isoCode: 'GB', name: 'United Kingdom', dialCode: '+44'),
  Country(isoCode: 'CA', name: 'Canada', dialCode: '+1'),
  Country(isoCode: 'GH', name: 'Ghana', dialCode: '+233'),
  Country(isoCode: 'KE', name: 'Kenya', dialCode: '+254'),
  Country(isoCode: 'ZA', name: 'South Africa', dialCode: '+27'),
  Country(isoCode: 'EG', name: 'Egypt', dialCode: '+20'),
  Country(isoCode: 'ET', name: 'Ethiopia', dialCode: '+251'),
  Country(isoCode: 'TZ', name: 'Tanzania', dialCode: '+255'),
  Country(isoCode: 'UG', name: 'Uganda', dialCode: '+256'),
  Country(isoCode: 'RW', name: 'Rwanda', dialCode: '+250'),
  Country(isoCode: 'SN', name: 'Senegal', dialCode: '+221'),
  Country(isoCode: 'CI', name: "Cote d'Ivoire", dialCode: '+225'),
  Country(isoCode: 'CM', name: 'Cameroon', dialCode: '+237'),
  Country(isoCode: 'MA', name: 'Morocco', dialCode: '+212'),
  Country(isoCode: 'DZ', name: 'Algeria', dialCode: '+213'),
  Country(isoCode: 'TN', name: 'Tunisia', dialCode: '+216'),
  Country(isoCode: 'AE', name: 'United Arab Emirates', dialCode: '+971'),
  Country(isoCode: 'SA', name: 'Saudi Arabia', dialCode: '+966'),
  Country(isoCode: 'QA', name: 'Qatar', dialCode: '+974'),
  Country(isoCode: 'IN', name: 'India', dialCode: '+91'),
  Country(isoCode: 'PK', name: 'Pakistan', dialCode: '+92'),
  Country(isoCode: 'CN', name: 'China', dialCode: '+86'),
  Country(isoCode: 'JP', name: 'Japan', dialCode: '+81'),
  Country(isoCode: 'KR', name: 'South Korea', dialCode: '+82'),
  Country(isoCode: 'SG', name: 'Singapore', dialCode: '+65'),
  Country(isoCode: 'MY', name: 'Malaysia', dialCode: '+60'),
  Country(isoCode: 'AU', name: 'Australia', dialCode: '+61'),
  Country(isoCode: 'NZ', name: 'New Zealand', dialCode: '+64'),
  Country(isoCode: 'DE', name: 'Germany', dialCode: '+49'),
  Country(isoCode: 'FR', name: 'France', dialCode: '+33'),
  Country(isoCode: 'ES', name: 'Spain', dialCode: '+34'),
  Country(isoCode: 'IT', name: 'Italy', dialCode: '+39'),
  Country(isoCode: 'NL', name: 'Netherlands', dialCode: '+31'),
  Country(isoCode: 'BE', name: 'Belgium', dialCode: '+32'),
  Country(isoCode: 'PT', name: 'Portugal', dialCode: '+351'),
  Country(isoCode: 'IE', name: 'Ireland', dialCode: '+353'),
  Country(isoCode: 'CH', name: 'Switzerland', dialCode: '+41'),
  Country(isoCode: 'SE', name: 'Sweden', dialCode: '+46'),
  Country(isoCode: 'NO', name: 'Norway', dialCode: '+47'),
  Country(isoCode: 'DK', name: 'Denmark', dialCode: '+45'),
  Country(isoCode: 'PL', name: 'Poland', dialCode: '+48'),
  Country(isoCode: 'TR', name: 'Turkey', dialCode: '+90'),
  Country(isoCode: 'BR', name: 'Brazil', dialCode: '+55'),
  Country(isoCode: 'MX', name: 'Mexico', dialCode: '+52'),
  Country(isoCode: 'AR', name: 'Argentina', dialCode: '+54'),
];