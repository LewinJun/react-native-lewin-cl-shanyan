/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Image} from 'react-native';
import CLShanYanSDK from 'react-native-lewin-cl-shanyan'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  async initAppId() {
    const res = await CLShanYanSDK.initWithAppId({appId: "", appKey: "", timeOut: 2});
    console.log(res);
  };

  async preGetPhonenumber() {
    const res = await CLShanYanSDK.preGetPhonenumber();
    console.log(res);
  };

  componentDidMount() {
    this.initAppId();
  }

  async quickLogin() {
    const res = await CLShanYanSDK.quickAuthLogin({ logo: require('./images/test.png') });
    console.log(res);
  }

  render() {
    return (
      <View style={styles.container}>
        <Text onPress={this.initAppId}>初始化</Text>
        <Text onPress={this.preGetPhonenumber}>预取号</Text>
        <Text onPress={this.quickLogin}>登录</Text>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
