import React, { useEffect, useState } from 'react';
import { TouchableOpacity, View } from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import GuardPage from './GuardHomeScreen';
import Icon from 'react-native-vector-icons/FontAwesome';
import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';
import { createDrawerNavigator, DrawerContentScrollView, DrawerItemList, DrawerItem } from '@react-navigation/drawer'
import CustomerHomeScreen from './CustomerHomeScreen';
import Salaries from './Salaries';
import Collections from './Collections';

const Drawer = createDrawerNavigator();

type RootStackParamList = {
  Login: undefined;
  GuardDrawer: { UID_Key: string };
  AddGuard: { UID_Key: string };
  GuardPage: { UID_Key: string };
  AddCustomer: { UID_Key: string };
  CustomerHomeScreen: { UID_Key: string };
};

type GuardDrawerPageProps = NativeStackScreenProps<RootStackParamList, 'GuardDrawer'>;

const GuardDrawer = ({ route, navigation }: GuardDrawerPageProps) => {
  const { UID_Key } = route.params;
  const [userName, setUserName] = useState<string>('');

  const handleAddGuard = () => {
    navigation.navigate("AddGuard", { UID_Key });
  }

  const handleAddCustomer = () => {
    navigation.navigate("AddCustomer", { UID_Key });
  }

  const handleSignOut = () => {
    auth()
      .signOut()
      .then(() => {
        console.log('User signed out!');
        navigation.navigate("Login");
      })
      .catch(error => {
        console.error('Sign out error:', error);
      });
  }

  const GetUserInfo = async () => {
    try {
      const snapshot = await firestore()
        .collection("All_Users").doc(UID_Key).get();

      console.log("DrawerScreen:", snapshot.data()?.UserName);
      setUserName(snapshot.data()?.UserName || 'User');
    } catch (error) {
      console.error('Error fetching user info:', error);
    }
  }

  useEffect(() => {
    if (UID_Key) {
      GetUserInfo();
    }
  }, [UID_Key]);

  return (
    <Drawer.Navigator initialRouteName="GuardPage" drawerContent={props => {
      return (
        <DrawerContentScrollView {...props}>
          <DrawerItemList {...props} />
          <DrawerItem label="Logout" labelStyle={{ color: "black" }} onPress={handleSignOut} style={{ backgroundColor: "lightgrey", marginTop: "200%", }} />
        </DrawerContentScrollView>
      );
    }}>
      <Drawer.Screen
        name="Guards"
        component={GuardPage}
        initialParams={{ UID_Key }}
        options={{
          headerTitle: `Welcome, ${userName}`,
          headerTitleStyle: { fontSize: 18 },
          headerStyle: {
            backgroundColor: 'black',
          },
          headerTintColor: 'white',
          headerTitleAlign: "center",
          headerRight: () => (
            <View style={{ flexDirection: 'row' }}>
              <TouchableOpacity onPress={handleAddGuard}>
                <Icon name="plus-circle" size={30} color="white" style={{ marginRight: 15 }} />
              </TouchableOpacity>
            </View>
          ),
        }}
      />
      <Drawer.Screen
        name="Customers"
        component={CustomerHomeScreen}
        initialParams={{ UID_Key }}
        options={{
          headerTitle: `Customers`,
          headerTitleStyle: { fontSize: 18 },
          headerStyle: {
            backgroundColor: 'black',
          },
          headerTintColor: 'white',
          headerTitleAlign: "center",
          headerRight: () => (
            <View style={{ flexDirection: 'row' }}>
              <TouchableOpacity onPress={handleAddCustomer}>
                <Icon name="plus-circle" size={30} color="white" style={{ marginRight: 15 }} />
              </TouchableOpacity>
            </View>
          ),
        }}
      />

      <Drawer.Screen
        name="Salaries"
        component={Salaries}
        initialParams={{ UID_Key }}
        options={{
          headerTitle: `Salaries`,
          headerTitleStyle: { fontSize: 18 },
          headerStyle: {
            backgroundColor: 'black',
          },
          headerTintColor: 'white',
          headerTitleAlign: "center",
        }}
      />
      <Drawer.Screen
        name="Collections"
        component={Collections}
        initialParams={{ UID_Key }}
        options={{
          headerTitle: `Collections`,
          headerTitleStyle: { fontSize: 18 },
          headerStyle: {
            backgroundColor: 'black',
          },
          headerTintColor: 'white',
          headerTitleAlign: "center",
        }}
      />

    </Drawer.Navigator>
  );
};

export default GuardDrawer;
