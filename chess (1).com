<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prom Invitation Puzzle</title>
    <style>
        body {
            text-align: center;
            font-family: Arial, sans-serif;
            background-color: #1a1a2e;
            color: white;
        }
        #puzzle-container {
            display: flex;
            flex-wrap: wrap;
            width: 300px;
            margin: 50px auto;
        }
        .puzzle-piece {
            width: 100px;
            height: 100px;
            border: 1px solid white;
            background-size: 300px 300px;
            cursor: grab;
        }
        #envelope {
            display: none;
            margin-top: 20px;
            font-size: 24px;
            padding: 20px;
            background: #f4a261;
            color: #1a1a2e;
            border-radius: 10px;
        }
        .button {
            background: #e63946;
            color: white;
            padding: 10px 20px;
            margin: 10px;
            border: none;
            cursor: pointer;
            font-size: 18px;
            border-radius: 5px;
        }
        .button:hover {
            background: #ff6b6b;
        }
    </style>
</head>
<body>
    <h1>Complete the Puzzle to Unlock Your Invitation</h1>
    <div id="puzzle-container"></div>
    
    <div id="envelope">
        <p>Are you willing to spend this night of chaos with me?</p>
        <button class="button" onclick="alert('hooraaaaaayyy!!')">Yes</button>
        <button class="button" onclick="alert('ipasa mo 'to sa bente katao para di ka maging hotdog')">No</button>
    </div>
    
    <script>
        const puzzleContainer = document.getElementById("puzzle-container");
        const envelope = document.getElementById("envelope");
        const imageURL = "https://via.placeholder.com/300"; 
        let positions = [0, 1, 2, 3, 4, 5, 6, 7, 8]; 
        positions = positions.sort(() => Math.random() - 0.5);
        
        function createPuzzle() {
            for (let i = 0; i < 9; i++) {
                let piece = document.createElement("div");
                piece.classList.add("puzzle-piece");
                piece.style.backgroundImage = `url('${imageURL}')`;
                piece.style.backgroundPosition = `${-100 * (positions[i] % 3)}px ${-100 * Math.floor(positions[i] / 3)}px`;
                piece.draggable = true;
                piece.setAttribute("data-index", positions[i]);
                piece.addEventListener("dragstart", dragStart);
                piece.addEventListener("dragover", dragOver);
                piece.addEventListener("drop", drop);
                puzzleContainer.appendChild(piece);
            }
        }
        
        function dragStart(event) {
            event.dataTransfer.setData("text", event.target.dataset.index);
        }
        
        function dragOver(event) {
            event.preventDefault();
        }
        
        function drop(event) {
            event.preventDefault();
            let draggedIndex = event.dataTransfer.getData("text");
            let targetIndex = event.target.dataset.index;
            
            let draggedPiece = document.querySelector(`[data-index='${draggedIndex}']`);
            let targetPiece = document.querySelector(`[data-index='${targetIndex}']`);
            
            [draggedPiece.dataset.index, targetPiece.dataset.index] = [targetIndex, draggedIndex];
            [draggedPiece.style.backgroundPosition, targetPiece.style.backgroundPosition] = [targetPiece.style.backgroundPosition, draggedPiece.style.backgroundPosition];
            
            checkPuzzle();
        }
        
        function checkPuzzle() {
            let correct = true;
            document.querySelectorAll(".puzzle-piece").forEach((piece, index) => {
                if (piece.dataset.index != index) correct = false;
            });
            if (correct) envelope.style.display = "block";
        }
        
        createPuzzle();
    </script>
</body>
</html>
