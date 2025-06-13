**Product Requirements Document (PRD)**

**Project Title:** Tradeasia Mobile

**Developer:** Gilang Liberty

**Client:** Tradeasia International

**Platform:** Flutter (Dart)


---

### 1. **Objective**
Develop a Flutter application that displays:
- A list of Top Products
- A detailed view of each product

The app must follow best practices in code structure (MVVM/BLoC), handle all UI states (loading, error, empty, and offline), and offer a clean, responsive design.

---

### 2. **Features**

#### 2.1 Top Products Page
- **API Endpoint:** `https://tradeasia.co/api/test/topProducts`
- **Method:** GET
- **Functionality:**
  - Display list of top products in a grid or list view
  - Each product item shows: product name, image, brief description, or price if available
  - Tapping on a product navigates to the detail page
  
#### 2.2 Product Details Page
- **API Endpoint:** `https://tradeasia.co/api/test/productDetails/{id}`
- **Method:** GET
- **Functionality:**
  - Fetch and show complete details of the selected product (image, name, description, and other data from API)
  - Back button to return to top products page

---

### 3. **Technical Requirements**

#### 3.1 Architecture
- Use **BLoC** or **MVVM** pattern (recommended: BLoC for better testability)
- Proper foldering for presentation, data, domain (if layered architecture is applied)

#### 3.2 State Management
- Handle the following UI states for both pages:
  - **Loading State:** Show shimmer/loading indicator
  - **Error State:** Show error message with retry button
  - **Empty State:** If no data is returned, display an empty placeholder with message
  - **Offline State:** Detect offline mode and show offline screen/message or cached data (use connectivity package)

#### 3.3 UI Design
- Responsive layout for both portrait and landscape
- Use consistent padding, typography, and theming
- Figma reference (optional to follow): https://bit.ly/TechnicalFlutterTradeasia

#### 3.4 Error Handling
- Use try-catch and BLoC error states
- Graceful fallbacks for missing or malformed data

#### 3.5 Bonus: Testing
- Unit test for bloc/view model logic
- Widget test for UI components (if time allows)

---

### 4. **Additional Enhancements (Optional/Recommended)**
- **Pull to Refresh** on the Top Products list
- **Cached Network Images** for better performance and offline support
- **Cached Product Data** locally (e.g. using Hive/shared_preferences)
- **Search Bar** in Top Products (basic string match)
- **Dark Mode Toggle** (if UI design allows)

---

### 5. **Deliverables**
- Flutter source code in a GitHub repository
- Link to GitHub repository sent via email:
  - **To:** webteam@chemtradeasia.com
  - **CC:** akmal@chemtradeasia.com, hisyam@chemtradeasia.com, aryo@chemtradeasia.com, hrd@chemtradeasia.com
  - **Subject:** `MobileDevTest_Tradeasia_GilangLiberty`

---

### 6. **Dependencies Suggestion**
- `flutter_bloc` or `provider`
- `dio` or `http` for networking
- `cached_network_image`
- `connectivity_plus`
- `flutter_lints`
- `equatable`
- `flutter_test` for unit/widget test

---


### 8. **Success Criteria**
- No crashes or runtime errors
- Clean, maintainable, and readable code
- Meets all functional requirements
- Bonus features included if time permits
- Github project is structured, with clear commit history

