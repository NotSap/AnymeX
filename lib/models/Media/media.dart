import 'package:anymex/controllers/service_handler/service_handler.dart';
import 'package:anymex/database/isar_models/chapter.dart';
import 'package:anymex/database/isar_models/offline_media.dart';
import 'package:anymex/models/Anilist/anilist_media_user.dart';
import 'package:anymex/models/Media/character.dart';
import 'package:anymex/models/Media/relation.dart';
import 'package:anymex/models/Media/staff.dart';
import 'package:anymex/models/models_convertor/carousel/carousel_data.dart';
import 'package:anymex/screens/novel/details/widgets/chapters_section.dart';
import 'package:anymex/utils/logger.dart';
import 'package:anymex_extension_runtime_bridge/anymex_extension_runtime_bridge.dart';

class Media {
  String id;
  String idMal;
  String title;
  String romajiTitle;
  String description;
  String poster;
  String largePoster;
  String? cover;
  String totalEpisodes;
  String type;
  String color;
  String season;
  String premiered;
  String duration;
  String status;
  String rating;
  String popularity;
  String format;
  String aired;
  ItemType mediaType;
  List<DEpisode>? mediaContent;
  List<Chapter>? altMediaContent;
  String? totalChapters;
  List<String> genres;
  List<String>? studios;
  List<Character>? characters;
  List<Staff>? staff;
  List<Relation>? relations;
  List<Media> recommendations;
  NextAiringEpisode? nextAiringEpisode;
  List<Ranking> rankings;
  ServicesType serviceType;
  DateTime? createdAt;
  bool? isAdult;
  String? sourceName;
  List<TrackedMedia>? friendsWatching;
  String? userStatus;
  String? characterRole;
  int? seasonYear;
  List<String> synonyms;
  List<Map<String, dynamic>>? tags;

  // String get uniqueId => "$id-${serviceType.name}";
  String get uniqueId => id.split('*').first;

  Media(
      {this.id = '0',
      this.idMal = '0',
      this.isAdult,
      this.mediaType = ItemType.anime,
      this.title = '?',
      this.color = '',
      this.romajiTitle = '?',
      this.description = '?',
      this.poster = '?',
      this.largePoster = '?',
      this.cover,
      this.totalEpisodes = '?',
      this.type = '?',
      this.season = '?',
      this.premiered = '?',
      this.duration = '?',
      this.status = 'ONGOING.. probably?',
      this.rating = '?',
      this.popularity = '?',
      this.format = '?',
      this.aired = '?',
      this.totalChapters = '?',
      this.genres = const [],
      this.studios,
      this.characters,
      this.staff,
      this.seasonYear,
      this.altMediaContent,
      this.relations,
      this.recommendations = const [],
      this.nextAiringEpisode,
      this.rankings = const [],
      this.mediaContent,
      required this.serviceType,
      this.sourceName,
      this.friendsWatching,
      this.userStatus,
      this.characterRole,
      this.synonyms = const [],
      this.tags,
      DateTime? createdAt})
      : createdAt = DateTime.now();

  factory Media.fromMAL(Map<String, dynamic> json) {
    final node = json['node'] ?? {};

    return Media(
      id: node['id']?.toString() ?? '0',
      title: node['title'] ?? '??',
      romajiTitle: node['alternative_titles']?['en'] ?? '??',
      description: node['synopsis'] ?? '??',
      poster: node['main_picture']?['medium'] ?? '??',
      cover: node['main_picture']?['large'] ?? '??',
      totalEpisodes: node['num_episodes']?.toString() ?? '??',
      type: node['media_type'] ?? '??',
      season: node['start_season']?['season'] ?? '??',
      premiered: node['start_date'] ?? '??',
      duration: node['average_episode_duration']?.toString() ?? '??',
      status: (node['status'] ?? '??').replaceAll('_', ' '),
      rating: node['mean']?.toString() ?? '??',
      popularity: node['popularity']?.toString() ?? '??',
      format: node['media_type'] ?? '??',
      aired: node['start_date'] ?? '??',
      totalChapters: node['num_chapters']?.toString() ?? '??',
      genres: (node['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name']?.toString() ?? '??')
              .toList() ??
          [],
      studios: (node['studios'] as List<dynamic>?)
          ?.map((studio) => studio['name']?.toString() ?? '??')
          .toList(),
      characters: [],
      relations: [],
      recommendations: [],
      nextAiringEpisode: null,
      rankings: [],
      mediaContent: [],
      mediaType: node['media_type'] == 'tv' ? ItemType.anime : ItemType.manga,
      serviceType: ServicesType.mal,
    );
  }

  factory Media.fromJikan(Map<String, dynamic> json, {bool isManga = false}) {
    return Media(
      id: json['mal_id']?.toString() ?? '0',
      title: json['title'] ?? '??',
      romajiTitle: json['title_english'] ?? json['title'] ?? '??',
      description: json['synopsis'] ?? '??',
      poster: json['images']?['jpg']?['image_url'] ?? '??',
      cover: json['images']?['jpg']?['large_image_url'] ??
          json['images']?['jpg']?['image_url'] ??
          '??',
      totalEpisodes: json['episodes']?.toString() ?? '??',
      totalChapters: json['chapters']?.toString() ?? '??',
      type: json['type'] ?? '??',
      season: json['season'] ?? '??',
      premiered: json['aired']?['from'] ?? json['published']?['from'] ?? '??',
      duration: json['duration'] ?? '??',
      status: (json['status'] ?? '??').replaceAll('_', ' '),
      rating: json['score']?.toString() ?? '??',
      popularity: json['popularity']?.toString() ?? '??',
      format: json['type'] ?? '??',
      aired: json['aired']?['from'] ?? json['published']?['from'] ?? '??',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => g['name']?.toString() ?? '??')
              .toList() ??
          [],
      studios: (json['studios'] as List<dynamic>?)
          ?.map((s) => s['name']?.toString() ?? '??')
          .toList(),
      characters: [],
      relations: [],
      recommendations: [],
      nextAiringEpisode: null,
      rankings: [],
      mediaContent: [],
      mediaType: isManga ? ItemType.manga : ItemType.anime,
      serviceType: ServicesType.mal,
    );
  }

  factory Media.fromFullMAL(Map<String, dynamic> json) {
    final node = json;

    return Media(
      id: node['id']?.toString() ?? '0',
      title: node['title'] ?? '??',
      romajiTitle: node['alternative_titles']?['en'] ?? '??',
      description: node['synopsis'] ?? '??',
      poster: node['main_picture']?['medium'] ?? '??',
      cover: node['main_picture']?['large'] ?? '??',
      totalEpisodes: node['num_episodes']?.toString() ?? '??',
      type: node['media_type']?.toUpperCase() ?? '??',
      season: node['start_season']?['season'] ?? '??',
      premiered: node['start_date'] ?? '??',
      duration: node['average_episode_duration']?.toString() ?? '??',
      status: node['status']?.replaceAll('_', ' ')?.toUpperCase() ?? '??',
      rating: node['mean']?.toString() ?? '??',
      popularity: node['popularity']?.toString() ?? '??',
      format: node['media_type'] ?? '??',
      aired: node['start_date'] ?? '??',
      totalChapters: node['num_chapters']?.toString() ?? '??',
      genres: (node['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name']?.toString() ?? '??')
              .toList() ??
          [],
      studios: (node['studios'] as List<dynamic>?)
          ?.map((studio) => studio['name']?.toString() ?? '??')
          .toList(),
      characters: [],
      recommendations: (node['recommendations'] as List<dynamic>?)
              ?.map((e) => Media.fromMAL(e))
              .toList() ??
          [],
      nextAiringEpisode: null,
      rankings: [],
      mediaContent: [],
      mediaType: node['media_type'] == 'tv' ? ItemType.anime : ItemType.manga,
      serviceType: ServicesType.mal,
    );
  }

  factory Media.fromSimkl(Map<String?, dynamic> json, bool isMovie) {
    ItemType type = ItemType.anime;

    return Media(
      id: '${json['ids']?['simkl_id']?.toString() ?? json['ids']?['simkl']?.toString()}*${isMovie ? "MOVIE" : "SERIES"}',
      title: json['title'] ?? 'Unknown Title',
      romajiTitle: json['title'] ?? 'Unknown Romaji Title',
      description: json['overview'] ?? 'No description available.',
      poster: json['poster'] != null
          ? 'https://wsrv.nl/?url=https://simkl.in/posters/${json['poster']}_m.jpg'
          : '',
      cover: json['fanart'] != null
          ? 'https://wsrv.nl/?url=https://simkl.in/fanart/${json['fanart']}_medium.jpg'
          : null,
      totalEpisodes: json['total_episodes']?.toString() ?? '1',
      type: json['country']?.toUpperCase() ?? 'UNKNOWN',
      premiered: json['released'] ?? 'Unknown release date',
      duration: json['runtime'] != null
          ? '${json['runtime']} minutes'
          : 'Unknown runtime',
      status: json['type']?.toUpperCase() ?? 'UNKNOWN',
      rating: json['ratings']?['simkl']?['rating']?.toString() ?? 'N/A',
      popularity: json['rank']?.toString() ?? '0',
      mediaType: type,
      aired: json['released'] ?? 'Unknown air date',
      totalChapters: '0',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre.toString())
              .toList() ??
          [],
      recommendations: (json['users_recommendations'] as List<dynamic>?)
              ?.map((e) {
                try {
                  return Media.fromSmallSimkl(e, isMovie);
                } catch (error) {
                  Logger.i('Error parsing recommendation: $error');
                  return null;
                }
              })
              .where((e) => e != null)
              .toList()
              .cast<Media>() ??
          [],
      serviceType: ServicesType.simkl,
    );
  }

  factory Media.fromSmallSimkl(Map<String?, dynamic> json, bool isMovie) {
    ItemType type = ItemType.anime;
    String posterUrl = '';
    if (json['poster'] != null) {
      if (json['poster'].toString().startsWith('http')) {
        posterUrl = json['poster'];
      } else {
        posterUrl = 'https://simkl.in/posters/${json['poster']}_m.jpg';
      }
    }

    String releaseDate = json['release_date'] ?? json['date'] ?? '';

    return Media(
      id: '${json['ids']?['simkl_id']?.toString() ?? json['ids']?['simkl']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString()}*${isMovie ? "MOVIE" : "SERIES"}',
      title: json['title'] ?? 'Unknown Title',
      romajiTitle: json['title'] ?? 'Unknown Romaji Title',
      description: json['overview'] ?? 'No description available.',
      poster: posterUrl,
      cover: null,
      totalEpisodes: json['total_episodes']?.toString() ?? '1',
      type: 'UNKNOWN',
      premiered: releaseDate,
      duration: 'Unknown runtime',
      status: 'UNKNOWN',
      rating: 'N/A',
      popularity: '0',
      mediaType: type,
      aired: releaseDate,
      totalChapters: '0',
      genres: [],
      recommendations: [],
      serviceType: ServicesType.simkl,
    );
  }

  factory Media.fromAnilist(Map<String, dynamic> json) {
    ItemType type = json['type'] == 'ANIME' ? ItemType.anime : ItemType.manga;
    final recs = (json['recommendations']?['edges'] as List?)
            ?.map((edge) => Media.fromAnilist(edge['node']['mediaRecommendation']))
            .toList() ??
        [];

    final media = Media(
      id: json['id'].toString(),
      idMal: json['idMal']?.toString() ?? '0',
      title: json['title']['english'] ?? json['title']['romaji'] ?? '?',
      description: json['description'] ?? '?',
      poster: json['coverImage']['large'] ?? '?',
      isAdult: json['isAdult'] ?? false,
      color: json['coverImage']['color'] ?? '',
      cover: json['bannerImage'],
      totalEpisodes: (json['episodes'] as int?)?.toString() ?? '?',
      type: json['type'] ?? '?',
      season: json['season'] ?? '?',
      premiered: '${json['season'] ?? '?'} ${json['seasonYear'] ?? '?'}',
      duration: '${json['duration'] ?? '?'}m',
      status: (json['status'] ?? '?').replaceAll('_', ' '),
      rating: ((json['averageScore'] ?? 0) / 10).toString(),
      popularity: json['popularity']?.toString() ?? '6900',
      format: json['format'] ?? '?',
      aired: _parseDateRange(json['startDate'], json['endDate']),
      seasonYear: json['seasonYear'] ?? json['startDate']?['year'],
      totalChapters: json['chapters']?.toString() ?? '?',
      genres: List<String>.from(json['genres'] ?? []),
      synonyms: List<String>.from(json['synonyms'] ?? []),
      tags: (json['tags'] as List?)
          ?.map((tag) => {
                'name': tag['name'],
                'rank': tag['rank'],
              })
          .toList(),
      studios: (json['studios']?['nodes'] as List?)
              ?.map((el) => el['name'].toString())
              .toList() ??
          [],
      characters: (json['characters']?['edges'] as List?)
          ?.map((character) => Character.fromJson(character))
          .toList(),
      relations: (json['relations']?['edges'] as List?)
              ?.map((relation) => Relation.fromJson(relation))
              .toList() ??
          [],
      recommendations: recs,
      nextAiringEpisode: json['nextAiringEpisode'] != null
          ? NextAiringEpisode.fromJson(json['nextAiringEpisode'])
          : null,
      rankings: (json['rankings'] as List?)
              ?.map((ranking) => Ranking.fromJson(ranking))
              .toList() ??
          [],
      mediaType: type,
      serviceType: ServicesType.anilist,
    );

    if (json['staffPreview'] != null) {
      media.staff = (json['staffPreview']['edges'] as List?)
          ?.map((staff) => Staff.fromJson(staff))
          .toList();
    }

    return media;
  }

  factory Media.fromAnilistCharacter(Map<String, dynamic> json) {
    ItemType type = json['type'] == 'ANIME' ? ItemType.anime : ItemType.manga;
    return Media(
      id: json['id'].toString(),
      title: json['title']['english'] ??
          json['title']['romaji'] ??
          json['title']['userPreferred'] ??
          '?',
      description: '',
      poster: json['coverImage']['large'] ?? '?',
      totalEpisodes: '?',
      type: json['type'] ?? '?',
      season: '?',
      premiered: '?',
      duration: '?',
      status: '?',
      rating: ((json['averageScore'] ?? 0) / 10).toString(),
      popularity: '?',
      format: json['format'] ?? '?',
      aired: '?',
      genres: [],
      mediaType: type,
      serviceType: ServicesType.anilist,
      nextAiringEpisode: json['nextAiringEpisode'] != null
          ? NextAiringEpisode.fromJson(json['nextAiringEpisode'])
          : null,
    );
  }

  static String _parseDateRange(
      Map<String, dynamic>? start, Map<String, dynamic>? end) {
    if (start == null && end == null) return 'Unknown';
    final startDate = _formatDate(start);
    final endDate = _formatDate(end);
    return '$startDate to $endDate';
  }

  static String _formatDate(Map<String, dynamic>? date) {
    if (date == null) return '?';
    return '${date['year'] ?? '?'}-${date['month']?.toString().padLeft(2, '0') ?? '?'}-${date['day']?.toString().padLeft(2, '0') ?? '?'}';
  }
}
