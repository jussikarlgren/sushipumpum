import java.util.*;

public class TermTabell extends java.util.Hashtable {
Hashtable l�ngder;
int l�ngst;

public TermTabell() {l�ngder = new Hashtable(); l�ngst = 0;};

  public void increment(String term, int l�ngd) {
if (l�ngd > l�ngst) {l�ngst = l�ngd;};
Integer i = new Integer(l�ngd);
         Vector v;
        if (l�ngder.containsKey(i)) {
              v = (Vector)l�ngder.get(i);
if (! v.contains(term)) {        v.addElement(term);};
        } else {
              v = new Vector();
        v.addElement(term);
        };            
        l�ngder.put(new Integer(l�ngd),v);
        if (containsKey(term)) {
	   put(term,new Integer((((Integer)get(term)).intValue())+1));
        } else {
          put(term,new Integer(1));
        };
  };


public void skrivUt() {skrivUt(2,2);};
public void skrivUt(int tr�skel, int ftr�skel) {
String s;
Enumeration ee;
Vector v;
Integer i;
int k;
for(int ii=l�ngst;ii >= tr�skel; ii--) {
         i = new Integer(ii);
        if (l�ngder.containsKey(i)) {
              v = (Vector)l�ngder.get(i);
              ee = v.elements();
              while (ee.hasMoreElements()) {
                 s = (String)ee.nextElement();
      k = ((Integer)get(s)).intValue();     
if (k >= ftr�skel) {                 System.out.println(k+" "+s+" "+i);};
        };            
}
}
}
};

