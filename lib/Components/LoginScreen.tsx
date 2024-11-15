import React, { useState } from "react";
import { SafeAreaView, StyleSheet, TextInput, View, Alert } from "react-native";
import PrimaryButton from "./PrimaryButton";
import Icon from 'react-native-vector-icons/FontAwesome';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import auth from '@react-native-firebase/auth';

export type RootStackParamList = {
    Login: undefined;
    GuardDrawer: { UID_Key: string };
    AddGuard: undefined;
};

type LoginScreenProps = NativeStackScreenProps<RootStackParamList, 'Login'>;

function LoginScreen({ navigation }: LoginScreenProps) {
    const [focusedField, setFocusedField] = useState<string | null>(null);
    const [email, setEmail] = useState<string>('');
    const [password, setPassword] = useState<string>('');

    const handleSignIn = async () => {
        if (email && password) {
            try {
                const response = await auth().signInWithEmailAndPassword(email, password);
                console.log("Response from Login Page: ", response.user.uid);
                setPassword("");
                navigation.navigate("GuardDrawer", { UID_Key: response.user.uid });
            } catch (error: any) {
                switch (error.code) {
                    case 'auth/email-already-in-use':
                        Alert.alert("Email Already in Use", "That email address is already in use!");
                        break;
                    case 'auth/invalid-email':
                        Alert.alert("Invalid Email", "That email address is invalid!");
                        break;
                    case 'auth/weak-password':
                        Alert.alert("Weak Password", "Password should be at least 6 characters");
                        break;
                    case 'auth/invalid-credential':
                        Alert.alert("Error", "Invalid Credentials");
                        break;
                    default:
                        Alert.alert("Error", "Something went Wrong. Try Again!");
                        break;
                }
                console.error(error);
            }
        } else {
            Alert.alert("Enter Email & Password First");
        }
    };

    return (
        <SafeAreaView style={styles.loginPageContainer}>
            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="envelope" size={26} color={focusedField === 'email' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Email"
                    onFocus={() => setFocusedField('email')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={setEmail}
                    value={email}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="lock" size={30} color={focusedField === 'pass' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Password"
                    secureTextEntry={true}
                    onFocus={() => setFocusedField('pass')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={setPassword}
                    value={password}
                />
            </View>
            <View style={styles.buttonContainer}>
                <PrimaryButton onPress={handleSignIn} text="Login" color="black" textcolor="white" />
            </View>
        </SafeAreaView>
    );
}

export default LoginScreen;

const styles = StyleSheet.create({
    loginPageContainer: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 40,
    },
    textInputContainer: {
        backgroundColor: "lightgrey",
        width: "100%",
        height: 50,
        flexDirection: "row",
        borderRadius: 6,
        marginBottom: 15,
        borderBottomWidth: 1.5,
        borderBottomColor: "black",
    },
    textInputfeild: {
        flex: 1,
        paddingHorizontal: 10,
        paddingVertical: 7,
        fontSize: 16,
        color: "black",
    },
    iconContainer: {
        width: 50,
        justifyContent: "center",
        alignItems: "center",
    },
    icon: {},
    buttonContainer: {
        marginTop: 30,
        width: "100%",
    },
});
