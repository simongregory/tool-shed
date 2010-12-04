//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright 2010 the original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

//public interface IPacket
/*
public interface IPacket
*/
package org.shed.bench.box
{

/**
 * A trickier fixture to test the <code>as-concrete</code> tool against.
 *
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 *
 * @author Simon Gregory
 */
public interface ISeedPacket
{
    /**
     * Sets the seed variety.
     *
     * @return
     */
    function variety(one:Number,
                     two:String,
                     three:Function):String;

     /**
      * Sets the seed variety.
      *
      * @return
      */
     function age(planted:Date,
                  details:String="a,b,c"):Date;

    /**
     * @private
     */
    function get material():String;
    function set material(value:String):void;

    /*

    function cheese(
                    stilton:Boolean
                        ):void;

    */

    function have(a:String, ...rest):Boolean;

    function plant(a:String,
                   b:Boolean=false,
                   c:Seed=pod):Boolean;
}
}