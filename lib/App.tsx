import React from "react";
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HomeScreen from "./Components/MainScreen"
import LoginScreen from "./Components/LoginScreen";
import SignUpScreen from "./Components/SignUpScreen";
import GuardDrawer from "./Components/GuardDrawer";
import AddGuard from "./Components/AddGuard";
import GuardDetails from "./Components/GuardDetails";
import AddCustomer from "./Components/AddCustomer";
import CustomerDetails from "./Components/CustomerDetails";
import AssignGuards from "./Components/AssignGuards";
import RemoveGuards from "./Components/RemoveGuards";



type RootStackParamList = {
  Home: undefined;
  Login: undefined;
  SignUp: undefined;
  GuardDrawer: { UID_Key: string };
  AddGuard: { UID_Key: string };
  GuardDetails: { guardId: string };
  EditGuardDetails: undefined;
  AddCustomer: { UID_Key: string };
  CustomerDetails: { CustomerID: string };
  AssignGuards: { UID_Key: string, CUS_ID: string };
  RemoveGuards: { UID_Key: string, CUS_ID: string };
};

const Stack = createNativeStackNavigator<RootStackParamList>();

function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen options={{ headerShown: false }} name="Home" component={HomeScreen} />
        <Stack.Screen options={{ headerShown: false }} name="Login" component={LoginScreen} />
        <Stack.Screen options={{ headerShown: false }} name="SignUp" component={SignUpScreen} />
        <Stack.Screen options={{ headerShown: false }} name="GuardDrawer" component={GuardDrawer} />
        <Stack.Screen options={{ headerTitle: "Add Guard", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="AddGuard" component={AddGuard} />

        <Stack.Screen options={{ headerTitle: "Guard Details", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="GuardDetails" component={GuardDetails} />

        <Stack.Screen options={{ headerTitle: "Add Customer", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="AddCustomer" component={AddCustomer} />

        <Stack.Screen options={{ headerTitle: "Customer Details", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="CustomerDetails" component={CustomerDetails} />

        <Stack.Screen options={{ headerTitle: "Assign Guards", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="AssignGuards" component={AssignGuards} />

        <Stack.Screen options={{ headerTitle: "Remove Guards", headerStyle: { backgroundColor: "black" }, headerTintColor: "white", headerTitleAlign: "center" }} name="RemoveGuards" component={RemoveGuards} />

      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default App;



