# Changelog

## 1.2.0

- Updated dependencies to their latest versions.
- Refactored `QuizController` to improve code readability and maintainability.
- Added unit tests for `QuizController` to ensure correct behavior and improve test coverage.
- Updated Models to include JSON serialization support using `json_serializable`.
- Refactored `UserModel` to include JSON serialization support and updated its structure to better fit the application's needs.
- Updated `QuestionModel` to include JSON serialization support and added a new field for the question category.
- Updated `QuizCategoryModel` to include JSON serialization support and added a new field for the list of questions in the category.
- Updated documentation for all models and services to reflect the changes made in this version.


## 1.1.0

- Updated dependencies to their latest versions.
- Added `json_annotation`, `build_runner`, and `json_serializable` for JSON serialization support.
- Refactored `CustomException` to be a concrete class instead of an abstract class.
- Added `toJson` method to `CustomException` for easier serialization of exceptions.
- Updated documentation for `CustomException` and its subclasses.
- Api v1 and v2 are now supported.
- Updated `QuizController` to handle both API versions and route requests accordingly.
- Added error handling for unsupported API versions in `QuizController`.

## 1.0.0

- Initial version.
