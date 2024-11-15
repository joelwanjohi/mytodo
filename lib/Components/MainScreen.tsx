import { SafeAreaView, StyleSheet, Text, View, Image } from "react-native";
import PrimaryButton from "./PrimaryButton";
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator, NativeStackScreenProps } from '@react-navigation/native-stack';

type RootStackParamList = {
  Home: undefined;
  Login: undefined;
  SignUp: undefined;
  GuardHome: undefined;
};

type HomeScreenProps = NativeStackScreenProps<RootStackParamList, 'Home'>;

function HomeScreen({ navigation }: HomeScreenProps) {
  return (
    <SafeAreaView style={styles.pageContainer}>
      <View style={styles.textContainer}>
        <Image style={styles.image} source={require("../Images/guard.png")} />
        <Text style={styles.textStyle}>Security Guard</Text>
      </View>
      <View style={styles.buttonsContainer}>
        <PrimaryButton text="Login" onPress={() => navigation.navigate('Login')} color="black" textcolor="white" />
        <PrimaryButton text="SignUp" onPress={() => navigation.navigate('SignUp')} />
      </View>
    </SafeAreaView>
  );
}

export default HomeScreen;

const styles = StyleSheet.create({
  pageContainer: {
    flex: 1,
    backgroundColor: "white",
    padding: 10,
  },
  textContainer: {
    flex: 5,
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
  },
  image: {
    height: 45,
    width: 45,
  },
  textStyle: {
    color: "black",
    fontSize: 32,
    fontWeight: "bold",
    marginLeft: 20,
  },
  buttonsContainer: {
    flex: 1,
    padding: 5,
    justifyContent: "space-evenly",
  },
});
