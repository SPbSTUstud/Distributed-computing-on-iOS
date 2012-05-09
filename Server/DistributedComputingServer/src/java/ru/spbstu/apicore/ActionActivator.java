package ru.spbstu.apicore;

import ru.spbstu.apicore.actions.IServerAction;

/**
 *
 * @author igofed
 */
public class ActionActivator {

   public static IServerAction getAction(String actionName) {
       
       Class clazz = null;
       IServerAction action = null;
        
       try{
          clazz = Class.forName("ru.spbstu.apicore.actions." + actionName + "Action");
          
          action = (IServerAction)clazz.newInstance();
         
          //todo: add throws
       } catch(ClassNotFoundException ex) {
           
       } catch(IllegalAccessException ex) {
           
       } catch(InstantiationException ex){
           
       }
       
       return action;
   }
}
