

import SwiftUI

struct CardData : Identifiable {
    var id : Int
    var name : String
    var offset : CGFloat
}






struct ContentView: View {
    @State var offset = 0
    @State var swiped = 0
    @State var data = [CardData(id: 0, name: "FIRST", offset: 0) , CardData(id: 1, name: "SECOND", offset: 0) , CardData(id: 2, name: "THIRD", offset: 0)]
    
    
    func getRotation(offset:CGFloat)->Double{
     
        let value = offset / 50
        let angle : CGFloat = 10
        print(value * angle , offset)
        return value * angle
    }

    var body: some View {
        VStack {
 
                ZStack{
                    ForEach(data.reversed()) { datum in
                        Mine(datum: datum , swiped: $swiped)
                        .offset(x:CGFloat(datum.offset))
                        .rotationEffect(.init(degrees: getRotation(offset: CGFloat(datum.offset))))
                        .gesture(DragGesture().onChanged(
                            {(value) in
                        
                                withAnimation{
                                    
                                data[datum.id].offset = value.translation.width
                                }
                    
                            }
                        ).onEnded(){value  in
                          
                        
                            withAnimation{
                                if( value.translation.width > 150 || value.translation.width < -150  ){
                                    var new = datum
                                    data[datum.id].offset = 1000
                                    new.id = data.count
                                    new.offset = 0
                                    data.append(new)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                        data[data.count-1].offset = 0
                                    }
                                }else{
                                    data[datum.id].offset = 0
                                }
                                
                            
                            }
                            swiped = datum.id + 1
                            print(datum , data)
                           // data[datum.id].offset = 1000
                        })
                    }
                }
        }
        .padding()
    }
}


struct Mine : View{
    @State var datum : CardData
    @Binding var swiped : Int
    var body: some View{
        VStack{
            Text("\(datum.name) \(datum.id) \(swiped)").background(
                Rectangle()
                    .fill(.red)
                    .frame(width:150 , height: 300)
            
                    .shadow(color:.black , radius: 5 , x:0 , y:5)
            )
            .padding(.vertical , 10)
            .padding(.horizontal , 30 + CGFloat(datum.id - swiped) * 10)
            .offset(y: datum.id - swiped <= 2 ? CGFloat(datum.id-swiped) * 25 : 50)
        }
    }
}
#Preview {
    ContentView()
}
