import tensorflow as tf

graph = tf.Graph()
with graph.as_default():
    a = tf.constant(1)
    b = tf.constant(2)
    c = tf.add(a, b)

    graph.finalize()

    # 这一行将引发错误，因为图已经被冻结
    d = tf.multiply(a, b)

