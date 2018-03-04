package com.datafibers.spark

import org.apache.spark.{SparkConf, SparkContext}

/**
  * Created by will on 2016-11-21.
  */
object SparkRDD {

  def main(args: Array[String]) {

    //Configuration for a Spark application.
    val conf = new SparkConf()
    conf.setAppName("SparkWordCount").setMaster("local")

    //Create Spark Context
    val sc = new SparkContext(conf)

    val a = sc.parallelize(List("dog", "salmon", "pig"), 3)
    val b = a.map(x => (x, x.length))
    b.collect.foreach(println)
    println("The partition size is: " + b.partitions.size)

  }
}
