class DutSchoolYear {
  int week;
  String schoolYear;
  int schoolYearVal;

  DutSchoolYear({
    required this.schoolYear,
    required this.schoolYearVal,
    required this.week,
  });

  @override
  String toString() {
    return "School year: $schoolYear\nSchool year value: $schoolYearVal\nWeek $week";
  }
}
