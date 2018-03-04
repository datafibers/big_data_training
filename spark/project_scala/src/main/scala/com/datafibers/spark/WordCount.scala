package com.datafibers.spark

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object WordCount {

  def main(args: Array[String]) {

    //check proper parameters - optional
    if (args.length < 1) {
      System.err.println("Usage: <file>")
      System.exit(1)
    }

    //Configuration for a Spark application.
    val conf = new SparkConf()
    conf.setAppName("SparkWordCount").setMaster("local")

    //Create Spark Context
    val sc = new SparkContext(conf)

    //Create MappedRDD by reading from HDFS file from path command line parameter
    val rdd = sc.textFile(args(0))

    //WordCount
    rdd.flatMap(_.split(" ")).
      map((_, 1)).
      reduceByKey(_ + _).
      map(x => (x._2, x._1)).
      sortByKey(false).
      map(x => (x._2, x._1)).take(10).foreach(x=>println(x))
      //saveAsTextFile("SparkWordCountResult")

    //stop context
    sc.stop
  }
}