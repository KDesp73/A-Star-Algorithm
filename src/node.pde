class Node {
  int x, y;
  boolean obstacle;
  boolean visited;
  
  float gScore;    // Cost from start node to current node
  float fScore;    // Total estimated cost from start to goal through the current node
  
  Node parent;
  
  Node(int x, int y) {
    this.x = x;
    this.y = y;
    obstacle = false;
    visited = false;
    gScore = Float.MAX_VALUE;
    fScore = Float.MAX_VALUE;
    parent = null;
  }
  
  // Function to calculate the heuristic value (Euclidean distance to the goal)
  float heuristic(Node goal) {
    float dx = x - goal.x;
    float dy = y - goal.y;
    return sqrt(dx*dx + dy*dy);
  }
}
