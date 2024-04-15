import '../model/favorite_school_model.dart';

String getBoxKey(FavoriteSchoolModel favoriteSchoolModel) {
  return "${favoriteSchoolModel.SD_SCHUL_CODE}${favoriteSchoolModel.SCHUL_NM}";
}
