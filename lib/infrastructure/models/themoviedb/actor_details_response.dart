// class ActorDetailsResponse {
//     final bool         adult;
//     final List<String> alsoKnownAs;
//     final String       biography;
//     final String       birthday;
//     final String       deathday;
//     final int          gender;
//     final String       homepage;
//     final int          id;
//     final String       imdbId;
//     final String       knownForDepartment;
//     final String       name;
//     final String       placeOfBirth;
//     final double       popularity;
//     final String       profilePath;

//     ActorDetailsResponse({
//         required this.adult,
//         required this.alsoKnownAs,
//         required this.biography,
//         required this.birthday,
//         required this.deathday,
//         required this.gender,
//         required this.homepage,
//         required this.id,
//         required this.imdbId,
//         required this.knownForDepartment,
//         required this.name,
//         required this.placeOfBirth,
//         required this.popularity,
//         required this.profilePath,
//     });

//     factory ActorDetailsResponse.fromJson(Map<String, dynamic> json) => ActorDetailsResponse(
//         adult:              json["adult"],
//         alsoKnownAs:        List<String>.from(json["also_known_as"].map((x) => x)),
//         biography:          json["biography"],
//         birthday:           json["birthday"],
//         deathday:           json["deathday"]  ?? '',
//         gender:             json["gender"],
//         homepage:           json["homepage"]  ?? '',
//         id:                 json["id"],
//         imdbId:             json["imdb_id"],
//         knownForDepartment: json["known_for_department"],
//         name:               json["name"],
//         placeOfBirth:       json["place_of_birth"],
//         popularity:         json["popularity"]?.toDouble(),
//         profilePath:        json["profile_path"],
//     );

//     Map<String, dynamic> toJson() => {
//         "adult":                adult,
//         "also_known_as":        List<dynamic>.from(alsoKnownAs.map((x) => x)),
//         "biography":            biography,
//         "birthday":             birthday,
//         "deathday":             deathday,
//         "gender":               gender,
//         "homepage":             homepage,
//         "id":                   id,
//         "imdb_id":              imdbId,
//         "known_for_department": knownForDepartment,
//         "name":                 name,
//         "place_of_birth":       placeOfBirth,
//         "popularity":           popularity,
//         "profile_path":         profilePath,
//     };
// }

class ActorDetailsResponse {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final String birthday;
  final String deathday;
  final int gender;
  final String homepage;
  final int id;
  final String imdbId;
  final String knownForDepartment;
  final String name;
  final String placeOfBirth;
  final double popularity;
  final String profilePath;
  final CombinedCredits combinedCredits;
  final Images images;

  ActorDetailsResponse({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.gender,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
    required this.combinedCredits,
    required this.images,
  });

  factory ActorDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ActorDetailsResponse(
        adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"],
        birthday: json["birthday"] ?? '',
        deathday: json["deathday"] ?? '',
        gender: json["gender"],
        homepage: json["homepage"] ?? '',
        id: json["id"],
        imdbId: json["imdb_id"] ?? '',
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"] ?? '',
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"] ?? '',
        combinedCredits: CombinedCredits.fromJson(json["combined_credits"]),
        images: Images.fromJson(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": List<dynamic>.from(alsoKnownAs.map((x) => x)),
        "biography": biography,
        "birthday": birthday,
        "deathday": deathday,
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
        "combined_credits": combinedCredits.toJson(),
        "images": images.toJson(),
      };
}

class CombinedCredits {
  final List<DetailsCast> cast;
  final List<DetailsCast> crew;

  CombinedCredits({
    required this.cast,
    required this.crew,
  });

  factory CombinedCredits.fromJson(Map<String, dynamic> json) =>
      CombinedCredits(
        cast: List<DetailsCast>.from(
            json["cast"].map((x) => DetailsCast.fromJson(x))),
        crew: List<DetailsCast>.from(
            json["crew"].map((x) => DetailsCast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class DetailsCast {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String? originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double voteAverage;
  final int voteCount;
  final String? character;
  final String creditId;
  final int? order;
  final String mediaType;
  final List<String>? originCountry;
  final String? originalName;
  final String? firstAirDate;
  final String? name;
  final int? episodeCount;
  final String? department;
  final String? job;

  DetailsCast({
    required this.adult,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.overview,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.creditId,
    required this.mediaType,
    required this.releaseDate,
    this.firstAirDate,
    this.originalTitle,
    this.backdropPath,
    this.posterPath,
    this.title,
    this.video,
    this.character,
    this.order,
    this.originCountry,
    this.originalName,
    this.name,
    this.episodeCount,
    this.department,
    this.job,
  });

  factory DetailsCast.fromJson(Map<String, dynamic> json) => DetailsCast(
        adult: json["adult"],
        backdropPath: json["backdrop_path"] ?? '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '',
        releaseDate: json["release_date"] ?? '',
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        mediaType: json["media_type"],
        originCountry: json["origin_country"] == null
            ? []
            : List<String>.from(json["origin_country"]!.map((x) => x)),
        originalName: json["original_name"],
        firstAirDate: json["first_air_date"],
        name: json["name"],
        episodeCount: json["episode_count"],
        department: json["department"],
        job: json["job"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "media_type": mediaType,
        "origin_country": originCountry == null
            ? []
            : List<dynamic>.from(originCountry!.map((x) => x)),
        "original_name": originalName,
        "first_air_date": firstAirDate,
        "name": name,
        "episode_count": episodeCount,
        "department": department,
        "job": job,
      };
}

class Images {
  final List<Profile> profiles;

  Images({
    required this.profiles,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        profiles: List<Profile>.from(
            json["profiles"].map((x) => Profile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
      };
}

class Profile {
  final double aspectRatio;
  final int height;
  final dynamic iso6391;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  Profile({
    required this.aspectRatio,
    required this.height,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
    this.iso6391,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        aspectRatio: json["aspect_ratio"]?.toDouble(),
        height: json["height"],
        iso6391: json["iso_639_1"],
        filePath: json["file_path"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "aspect_ratio": aspectRatio,
        "height": height,
        "iso_639_1": iso6391,
        "file_path": filePath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
      };
}
