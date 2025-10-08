class ApiConstants {
  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';
  
  // Story endpoints
  static const String topStories = '$baseUrl/topstories.json';
  static const String bestStories = '$baseUrl/beststories.json';
  static const String newStories = '$baseUrl/newstories.json';
  
  // Item endpoint (for fetching individual stories by ID)
  static String item(int id) => '$baseUrl/item/$id.json';
  
  // Pagination
  static const int pageSize = 20;
}