import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { multiply,playVideo } from 'mazadat-video-overlay';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    multiply(3, 7).then(setResult);
  }, []);
//"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button title='Open Video' onPress={()=>{playVideo("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")}}></Button>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
