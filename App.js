import React, {useEffect,  useState } from 'react';
import {View, Text, StyleSheet, Button} from 'react-native';
import { NativeModules, NativeEventEmitter} from 'react-native';


// console.log(NativeModules.Counter);
// NativeModules.Counter.increment(value => {
//   console.log('the count is ' + value);
// });
// console.log(NativeModules.Counter.getConstants());

const CounterEvents = new NativeEventEmitter(NativeModules.Counter);

const App = props => {
  const [ count , setCount ] = useState(0);
  useEffect(() => {
    CounterEvents.addListener('onIncrement', result =>
      console.log('onIncrement received', result),
    );
    CounterEvents.addListener('onDecrement', result =>
      console.log('onDecrement received', result),
    );

    return () => {
      CounterEvents.removeAllListeners();
    };
  }, []);


  const decrement = async () => {
    try {
      var result = await NativeModules.Counter.decrement();
      setCount(result);
    } catch (e) {
      console.log(e.message, e.code);
    }
  };

  const increment = async () => {
    NativeModules.Counter.increment(res => setCount(res));
    
  };

  return (
    <View style={styles.container}>
      <Text>Count {count}</Text>
      <Button title="Increase Count" onPress={increment} />
  
      <Button title="Decrease Count" onPress={decrement} />
    </View>
  );
};
export default App;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
