// A* algorithm implementation //<>// //<>// //<>// //<>//
//
// ==Controls==
// Left Click: Add obstacles
// Right Click: Add start and target points
// R: Remove start and target points
// Enter: Start the algorithm

int width = 600;
int height = width;

int cellSize = width / 20;
int[][] cells;
Node[][] nodes;

int rows = width / cellSize;
int cols = height / cellSize;

int START = 0;
int LINE = 1;
int TARGET = 2;
int WALL = 3;

Node startNode;
Node targetNode;

ArrayList<Node> openSet;
ArrayList<Node> closedSet;

boolean startPut = false;
boolean targetPut = false;
boolean algorithmStarted = false;

color startColor = color(46, 139, 87);
color lineColor = color(0, 136, 187);
color targetColor = color(227, 66, 52);
color backgroundColor = color(30, 33, 43);
color wallColor = color(0, 0, 0);

void setup() {
  size(600, 600);

  cells = new int[rows][cols];
  nodes = new Node[rows][cols];

  stroke(48);

  for (int i=0; i < rows; i++) {
    for (int j=0; j < cols; j++) {
      cells[i][j] = -1;
      nodes[i][j] = new Node(i, j);
    }
  }

  openSet = new ArrayList<Node>();
  closedSet = new ArrayList<Node>();

  background(color(32, 32, 32));
}

void draw() {
  if (algorithmStarted)
    A_star();

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      switch(cells[i][j]) {
      case 0:
        fill(startColor);
        break;
      case 1:
        fill(lineColor);
        break;
      case 2:
        fill(targetColor);
        break;
      case 3:
        fill(wallColor);
        break;
      default:
        fill(backgroundColor);
        break;
      }

      rect (i*cellSize, j*cellSize, cellSize, cellSize);
    }
  }

  if (keyPressed && key == 'r' || key == 'R') {
    startPut = false;
    targetPut = false;

    for (int i=0; i < rows; i++) {
      for (int j=0; j < cols; j++) {
        cells[i][j] = -1;
        nodes[i][j] = new Node(i, j);
      }
    }

    openSet = new ArrayList<Node>();
    closedSet = new ArrayList<Node>();
/*
    int[] startCoords = findValue(START);
    int[] targetCoords = findValue(TARGET);

    if (startCoords == null) return;
    if (targetCoords == null) return;

    cells[startCoords[0]][startCoords[1]] = -1;
    cells[targetCoords[0]][targetCoords[1]] = -1;
*/
  }
}

void A_star() {
  if (openSet.size() > 0) {
    int bestIndex = 0;
    for (int i = 0; i < openSet.size(); i++) {
      if (openSet.get(i).fScore < openSet.get(bestIndex).fScore) {
        bestIndex = i;
      }
    }

    Node current = openSet.get(bestIndex);

    if (current == targetNode) {
      // Path found, reconstruct and highlight the path
      ArrayList<Node> path = new ArrayList<Node>();
      Node temp = current;
      path.add(temp);
      while (temp.parent != null) {
        path.add(temp.parent);
        temp = temp.parent;
      }

      // Highlight the path
      for (int i = 0; i < path.size(); i++) {
        if (i == 0 || i == path.size() - 1) continue;
        Node node = path.get(i);
        cells[node.x][node.y] = LINE;
      }

      noLoop();
    }

    // Move the current node from open set to closed set
    openSet.remove(current);
    closedSet.add(current);

    // Process neighbors of the current node
    ArrayList<Node> neighbors = getNeighbors(current);
    for (Node neighbor : neighbors) {
      if (closedSet.contains(neighbor) || neighbor.obstacle) {
        continue; // Skip if already evaluated or is an obstacle
      }

      float tentativeGScore = current.gScore + 1; // Assuming a cost of 1 for each step

      if (!openSet.contains(neighbor)) {
        openSet.add(neighbor);
      } else if (tentativeGScore >= neighbor.gScore) {
        continue; // Skip if the tentative gScore is not better
      }

      neighbor.parent = current;
      neighbor.gScore = tentativeGScore;
      neighbor.fScore = neighbor.gScore + neighbor.heuristic(targetNode);
    }
  } else {
    // No path found
    println("No path found");
    noLoop();
  }
}

ArrayList<Node> getNeighbors(Node node) {
  ArrayList<Node> neighbors = new ArrayList<Node>();

  int x = node.x;
  int y = node.y;

  // Add left neighbor
  if (x > 0) {
    neighbors.add(nodes[x-1][y]);
  }

  // Add right neighbor
  if (x < cols - 1) {
    neighbors.add(nodes[x+1][y]);
  }

  // Add top neighbor
  if (y > 0) {
    neighbors.add(nodes[x][y-1]);
  }

  // Add bottom neighbor
  if (y < rows - 1) {
    neighbors.add(nodes[x][y+1]);
  }

  return neighbors;
}

void keyPressed() {
  if (keyCode == ENTER) {
    algorithmStarted = true;
    println("Algorithm started");
  }
}

void mouseClicked() {
  if (algorithmStarted) return;

  int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
  xCellOver = constrain(xCellOver, 0, width/cellSize-1);
  int yCellOver = int(map(mouseY, 0, width, 0, width/cellSize));
  yCellOver = constrain(yCellOver, 0, width/cellSize-1);

  if (mouseButton == LEFT) {
    cells[xCellOver][yCellOver] = WALL;
    nodes[xCellOver][yCellOver].obstacle = true;
  } else if (mouseButton == RIGHT) {
    if (targetPut) return;

    if (!startPut) {
      cells[xCellOver][yCellOver] = START;
      startNode = nodes[xCellOver][yCellOver];
      startPut = true;
    } else {
      cells[xCellOver][yCellOver] = TARGET;
      targetNode = nodes[xCellOver][yCellOver];

      // Add the start node to the open set
      openSet.add(startNode);

      // Set the gScore of the start node to 0
      startNode.gScore = 0;

      // Set the fScore of the start node to the heuristic value
      startNode.fScore = startNode.heuristic(targetNode);

      targetPut = true;
    }
  }
}

int[] findValue(int value) {
  for (int i = 0; i < width / cellSize; i++) {
    for (int j = 0; j < height /cellSize; j++) {
      if (cells[i][j] == value) return new int[]{i, j};
    }
  }
  return null;
}
