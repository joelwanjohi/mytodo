
This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

# 🛡️ Security Guard App

**Security Guard App** is a comprehensive solution for managing guard services, aimed at providing seamless management of guards and their assignment to customers. The application, built using React Native CLI with TypeScript, integrates Firebase for authentication and data management. 

## 📋 Features

- **🔒 Authentication**
  - Email/password authentication using Firebase.
  
- **🛠️ Admin Management**
  - View details regarding specific admins.
  
- **👮 Guard & Customer Management**
  - Add Guards & Customers to Firebase.
  - Update Guard & Customer information on Firebase.
  - Delete Guard & Customer from Firebase.
  
- **📋 Assignment**
  - Assign Guards to Customers.
  - Remove Guards from Customers.
  
- **💰 Salary Management**
  - Add salary details for Guards & Customers.
  
- **🔐 User Session Management**
  - Maintain user login state and allow for logout.

## 🚀 Getting Started

You can follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Node.js](https://nodejs.org/en/) (>= 12.x)
- [React Native CLI](https://reactnative.dev/docs/environment-setup)
- [Firebase Account](https://firebase.google.com/) (for backend services)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/security-guard-app.git
   cd security-guard-app

2. **Install dependencies:**
   ```bash
   npm install

3. **Configure Firebase:**
   - Go to your Firebase console.
   - Create a new project.
   - Enable Email/Password authentication.
   - Add your Firebase credentials in `firebaseConfig.ts` located in the root of the project.

4. **Run the application:**
   ```bash
   npx react-native run-android # for Android
   npx react-native run-ios # for iOS


## 📂 Project Structure

   ```plaintext
   .
   ├── Components
   │   ├── AddCustomer.tsx
   │   ├── AddGuard.tsx
   │   ├── AssignGuards.tsx
   │   ├── Collections.tsx
   │   ├── CustomerDetails.tsx
   │   ├── CustomerHomeScreen.tsx
   │   ├── GuardDetails.tsx
   │   ├── GuardDrawer.tsx
   │   ├── GuardHomeScreen.tsx
   │   ├── LoginScreen.tsx
   │   ├── MainScreen.tsx
   │   ├── PrimaryButton.tsx
   │   ├── RemoveGuards.tsx
   │   ├── Salaries.tsx
   │   ├── SignUpScreen.tsx
   ├── Images
   │   ├── ...
   ├── App.tsx
   ├── firebaseConfig.ts
   └── ...
```

## 🛠️ Built With

- **React Native CLI** - Cross-platform mobile app development framework.
- **TypeScript** - Superset of JavaScript with static types.
- **Firebase** - Backend-as-a-Service, providing authentication and real-time database services.

## ✨ Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## 📜 License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## 📞 Contact

For any inquiries, feel free to reach out:

- **Email:** alihere786@gmail.com
- **LinkedIn:** [Muhammad Ali](https://www.linkedin.com/in/m-ali-khattak/)




