package
{

public interface IShed
{
    function get windows():int;
    function set windows(value:int):void;

    function get doors():uint;

    function set lamps(value:Number):void;

    function openDoor():void;
    function startHeater(temperature:Number,fuel:String):void;
    function countTools():Number;
}
}