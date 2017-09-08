//some static element related methods:


//most basic graphics element framework. All elements will draw onto their parent.


//Fields: position, size, graphics, parent ?visibility, ?cursorhovering(only when clickListener is implemented), ?updaterequest
//Functions: setters(pos,size,vis), request update, draw self, reset graphics
abstract class Element {
  //The parent container. If this is a screen object, parent will be null and it will draw onto the physical screen. 
  Container parent;

  PVector pos;
  float w, h;

  PGraphics g;

  boolean visible = true;


  //Passive listeners only active if the listener is implemented

  //passive component of ClickListener
  boolean cursorhover = false;

  //if >0 tells the element that some data has changed and it should update itself before the next draw cycle.
  //most element types only have one kind of update, but things like shape types, which have regular updates and shape updates can use more than one update state. 
  int updatable;

  Element(float x, float y, float w, float h, Container p) {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
    resetGraphics();
    if (p != null) {
      p.add(this);
    }
  }
  void destroySelf() {
    print(this);
    parent.remove(this);
    destroyListeners();
  }
  //only listener objects may exist in listener lists
  void destroyListeners() {
    if (this instanceof Listener) {
      removeListener(this);
    }
  }

  //method for updating the element's graphics. 
  abstract void update();

  void requestUpdate() {
    //if updatable is true, then that implies that all the parent objects are pending an update too.
    updatable = 1;
    //considering conditional call if parent is not currently pending an update. 
    if (isConcrete()) {
      parent.requestUpdate();
    }
  }  
  //generally resetting graphics is done with the intent of drawing onto that graphics,so we begin draw.
  void resetGraphics() {
    g = createGraphics((int)w+1, (int)h+1);
    g.beginDraw();
  }
  PGraphics getGraphics() {
    return g;
  }
  //returns the sums of it and all it's parent's positions.
  PVector getGlobalPos() {
    return PVector.add(pos, parent.getGlobalPos());
  }
  //parent graphics
  PGraphics pg() {
    return parent.getGraphics();
  }
  //draws onto its parent's graphics
  void draw() {
    checkUpdates();
    //saves current transformation context, applies transform and draws, then restores previous transformation context.
    pg().pushMatrix();
    applyTransform();
    pg().image(getGraphics(), 0, 0); 
    pg().popMatrix();
  }
  void checkUpdates() {
    //if an update has been queued for this element do the business
    if (updatable>0) {
      updatable = 0;
      g.beginDraw();
      update();
      g.endDraw();
    }
  }
  void applyTransform() {
    pg().translate(pos.x, pos.y);
  }

  void setVisibility(boolean b) {
    visible = b;
    requestUpdate();
  }
  void setDimensions(float w, float h) {
    this.w = max(w, 0);
    this.h = max(h, 0);
    requestUpdate();
  }
  void setPosition(float x, float y) {
    pos.x = x;
    pos.y = y;
    requestUpdate();
  }
  void setParent(Container p) {
    if (parent != null) parent.remove(this);
    parent = p;
    requestUpdate();
  }
  //returns true if element has the ability to exist.
  //checks if the highest element in the parent heirachy is a screen object.
  boolean isConcrete() {
    if (parent == null) return false;
    return parent.isConcrete();
  }
}

//Containers add the ability to possess other Elements, but they do not have a PGraphics object, instead drawing directly onto their parent.
//Containers can be thought of as an extension of the parent element
//currently scrapped for game, may implement later.

class Collection extends Container {

  Collection(Container p) {
    //position in its parent is 0,0,but drawing size is identical to parent's
    //any uses for width and height are purely symbolic past this point.
    super(0, 0, 0, 0, p);    
    //the object draws directly onto the parent's graphics.
    g = pg();
  }
  //removed resetGraphics as this is now an addition to the parent's graphics.




  @Override
    void update() {

    drawChildren();
  }
  void draw() {
    checkUpdates();
    //saves current transformation context, applies transform and draws, then restores previous transformation context.
    pg().pushMatrix();
    applyTransform();
    pg().popMatrix();
  }
}
//Desc: can hold and draw multiple children elements. Getters and setters are a given.
class Container extends Element {
  ArrayList<Element> children;


  Container(float x, float y, float w, float h, Container p) {
    super(x, y, w, h, p);
    children = new ArrayList<Element>();
  }
  @Override
    void destroyListeners() {
    super.destroyListeners();
    for (Element e : children) {
      e.destroyListeners();
    }
  }
  void update() {
    resetGraphics();

    drawChildren();
  }

  //first element bottom, last element top
  void drawChildren() {
    for (Element e : children) {
      e.draw();
    }
  }

  ArrayList<Element> getChildren() {
    return children = new ArrayList(children);
  }

  void add(Element object) {
    object.setParent(this);
    children.add(object);
    requestUpdate();
  }
  //removal also involves removing them from all listener lists.
  void remove(Element object) {
    object.parent = null;
    children.remove(object);
    requestUpdate();
  }
  void remove(int index) {
    children.get(index).parent = null;
    children.remove(index);
    requestUpdate();
  }
  boolean replace(Element oldo, Element newo) {
    int index = children.lastIndexOf(oldo);
    if (index > -1) {
      newo.setParent(this);
      children.set(index, newo);
      return true;
    }
    return false;
  }
  //do I even have a grandson?
  boolean isChild(Element e) {
    return children.contains(e);
  }
}
//
abstract class Screen extends Container {

  Screen() {
    super(0, 0, width, height, null );
    requestUpdate();
  }
  @Override
    void destroySelf() {
    destroyListeners();
  }

  @Override
    void requestUpdate() {
    updatable = 1;
  }
  @Override
    PVector getGlobalPos() {
    return new PVector(0, 0);
  }
  @Override
    void draw() {
    checkUpdates();
    image(getGraphics(), pos.x, pos.y);
  }
  @Override
    boolean isConcrete() {
    return true;
  }
}