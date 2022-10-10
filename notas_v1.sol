// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notas {
    //direccion del profesor
    address public profesor;
    //Constructor
    constructor () public {
        profesor = msg.sender;
    }
    //Mapping para relacionar con el hash de la identidad del alumno con su nota del examen
    mapping (bytes32 => uint) Notas;
    //Array de los alumnos que pidan revisar el examen
    string [] revisiones;
    //Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);
    //Asociamos a los alumnos las notas; antes haremos privado su identidad; solo la puede ejecutar el profesor
    
    function Evaluar (string memory _idalumno, uint _nota ) public UnicamenteProfesor (msg.sender) {
        //hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256 (abi.encodePacked(_idalumno));
        //relación entre el hash del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        //Emision del evento
        emit alumno_evaluado (hash_idAlumno);
    }
    //Modificador para que solo pueda evaluar el professor
    modifier UnicamenteProfesor (address _direccion) {
        //Requiere que la direccion introducida por parametro sea igual al owner del contrato
        require (_direccion == profesor, "No tienes permisos para ejecutar esta funcion");
        _;

    }
    //Funcion para ver las notas de un alumno
    function VerNotas(string memory _idalumno) public view returns(uint){
         //hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256 (abi.encodePacked(_idalumno));
        //Nota asociada al hash del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        //Visualizar la nota
        return nota_alumno;
     }
    //Funcion para pedir una revisión del examen
    function Revision(string memory _idalumno) public {
        //Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idalumno);
        //Emision del evento
        emit evento_revision(_idalumno);

    }
    //Funcion para ver los alumnos que han solicitado revision de examen
    function VerRevisiones () public view UnicamenteProfesor(msg.sender) returns(string []memory) {
        //Devolver las identidades de los alumnos
        return revisiones;
    }

}


