import java.util.*;

public class TermTabell extends java.util.Hashtable {
Hashtable längder;
int längst;

public TermTabell() {längder = new Hashtable(); längst = 0;};

  public void increment(String term, int längd) {
if (längd > längst) {längst = längd;};
Integer i = new Integer(längd);
         Vector v;
        if (längder.containsKey(i)) {
              v = (Vector)längder.get(i);
if (! v.contains(term)) {        v.addElement(term);};
        } else {
              v = new Vector();
        v.addElement(term);
        };            
        längder.put(new Integer(längd),v);
        if (containsKey(term)) {
	   put(term,new Integer((((Integer)get(term)).intValue())+1));
        } else {
          put(term,new Integer(1));
        };
  };


public void skrivUt() {skrivUt(2,2);};
public void skrivUt(int tröskel, int ftröskel) {
String s;
Enumeration ee;
Vector v;
Integer i;
int k;
for(int ii=längst;ii >= tröskel; ii--) {
         i = new Integer(ii);
        if (längder.containsKey(i)) {
              v = (Vector)längder.get(i);
              ee = v.elements();
              while (ee.hasMoreElements()) {
                 s = (String)ee.nextElement();
      k = ((Integer)get(s)).intValue();     
if (k >= ftröskel) {                 System.out.println(k+" "+s+" "+i);};
        };            
}
}
}
};

