import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chips.dart';
import '../utils/colors.dart';
import 'course_detail_screen.dart';
import 'package:learnhub/providers/locale_provider.dart';

class CourseListingScreen extends StatefulWidget {
  const CourseListingScreen({Key? key}) : super(key: key);

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  final CourseService _courseService = CourseService();
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Enrolled', 'New', 'Popular'];
  List<Course> courses = [];
  List<Course> filteredCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      isLoading = true;
    });

    // For demo purposes, using sample data
    courses = _courseService.getSampleCourses();
    _filterCourses();

    setState(() {
      isLoading = false;
    });
  }

  void _filterCourses() {
    switch (selectedFilter) {
      case 'Enrolled':
        filteredCourses = courses.where((c) => c.isEnrolled).toList();
        break;
      case 'New':
        filteredCourses = courses.where((c) => !c.isEnrolled).toList();
        break;
      case 'Popular':
        filteredCourses = courses;
        break;
      default:
        filteredCourses = courses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final loc = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCard(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          loc.t('courses'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: AppColors.getTextPrimary(context),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            filters: filters.map((f) {
              switch (f) {
                case 'All': return loc.t('all');
                case 'Enrolled': return loc.t('enrolled');
                case 'New': return loc.t('new_filter');
                case 'Popular': return loc.t('popular');
                default: return f;
              }
            }).toList(),
            selectedFilter: () {
              switch (selectedFilter) {
                case 'All': return loc.t('all');
                case 'Enrolled': return loc.t('enrolled');
                case 'New': return loc.t('new_filter');
                case 'Popular': return loc.t('popular');
                default: return selectedFilter;
              }
            }(),
            onFilterSelected: (displayLabel) {
              // Map translated label back to English key
              String key = 'All';
              if (displayLabel == loc.t('all')) key = 'All';
              else if (displayLabel == loc.t('enrolled')) key = 'Enrolled';
              else if (displayLabel == loc.t('new_filter')) key = 'New';
              else if (displayLabel == loc.t('popular')) key = 'Popular';
              setState(() {
                selectedFilter = key;
                _filterCourses();
              });
            },
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : filteredCourses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 80,
                              color: isDarkMode 
                                  ? Colors.grey[700] 
                                  : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              loc.t('no_courses_found'),
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.getTextPrimary(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.t('try_changing_filter'),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadCourses,
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            return CourseCard(
                              course: filteredCourses[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDetailScreen(
                                      course: filteredCourses[index],
                                    ),
                                  ),
                                ).then((_) => _loadCourses());
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}