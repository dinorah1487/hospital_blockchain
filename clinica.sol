pragma solidity ^0.4.24;
contract hospital{
    address public owner;
    
    
    /* struct User {
        string name;
        
        string dni;
        string telefono;
        string fec_nac;
        string sexo;
        string direccion;
        string tipo_examen;
        string resultado;

    }
    
    mapping(address => User) private users;
     address [] public usuarios;
    
    mapping(address => bool) private joinedUsers;
    address[] total;

    function join(string name, string dni, string fec_nac, string sexo, string direccion, string telefono, string tipo_examen, string resultado ) public {
        require(!userJoined(msg.sender));
        User storage user = users[msg.sender];
        user.name = name;
        user.dni=dni;
        user.fec_nac=fec_nac;
        user.sexo=sexo;
        user.direccion=direccion;
        user.telefono=telefono;
        user.tipo_examen=tipo_examen;
        user.resultado=resultado;
        joinedUsers[msg.sender] = true;
        total.push(msg.sender);
      
        
        
    }

    function getUser(address addr) public view returns (string, string, string, string) {
        require(userJoined(msg.sender));
        User memory user = users[addr];
        return (user.name, user.dni, user.resultado, user.telefono);
    }    

    function userJoined(address addr) private view returns (bool) {
        return joinedUsers[addr];
    }

    function totalUsers() public view returns (uint) {
        return total.length;
    }*/
    //hasta aqui registro paciente
    
    
    
    
    
    
    struct Paciente{
        uint PuntosDeLealtad;
        uint totalExamenes;
    }
    struct ExamenClinico{
        string name;
        uint price;
        
    }
    uint etherperpoint=0.5 ether;
    
    ExamenClinico[] public TipoExamen;
    
    mapping (address=>Paciente) public paciente;
    mapping (address=>ExamenClinico[]) public PacientesPorExamen;
    mapping (address=>uint) public TotalExamenesporPaciente;
    
    event fligthpurchased(address indexed paciente, uint price);
    
    
    constructor(){
        owner=msg.sender;
        TipoExamen.push(ExamenClinico('Triaje covid', 4 ether));
        TipoExamen.push(ExamenClinico('Consulta externa', 2 ether));
        TipoExamen.push(ExamenClinico('Lab. clinico', 3 ether));
         TipoExamen.push(ExamenClinico('Colesterol', 5 ether));
         TipoExamen.push(ExamenClinico('Hemograma', 1 ether));
    }
    function PagoExamenClinico(uint PagoExamenindex) public payable{
        ExamenClinico examenClinico = TipoExamen[PagoExamenindex];
        require(msg.value==examenClinico.price);
        Paciente storage pacientes=paciente[msg.sender];
        pacientes.PuntosDeLealtad+=5;
        pacientes.totalExamenes+=1;
        PacientesPorExamen[msg.sender].push(examenClinico);
        TotalExamenesporPaciente[msg.sender]++;
        fligthpurchased(msg.sender, examenClinico.price);
        
    }
    function ExamenesDisponibles() public view returns (uint){
        
        return TipoExamen.length;
        
    }
    function redeemLoyaltypoints() public{
        Paciente storage pacientes=paciente[msg.sender];
        uint ethertoRefound=etherperpoint*pacientes.PuntosDeLealtad;
        msg.sender.transfer(ethertoRefound);
        pacientes.PuntosDeLealtad=0;
    }
    
    function ReintegroEnEther() public view returns(uint){
        return etherperpoint*paciente[msg.sender].PuntosDeLealtad;
    }
    function MontoAPagar() public isOwner view returns (uint){
        address airlineAddress=this;
        return airlineAddress.balance;
    }
    
    modifier isOwner{
        require(msg.sender==owner);
        _;
    }
    
    
}