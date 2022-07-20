using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace EasyGameStudio.scanner
{
    public class Scanner_quad_control : MonoBehaviour
    {
        
        // [SerializeField, Range(0.1f, 20)]

        [Header("speed")]
        public float speed;

        [Header("destory time")]
        public float delay_destory_time = 10;


        private float time_stamp;
        private float max_distance;
        private Camera cam;


        void Awake()
        {
            this.cam = Camera.main;
            this.time_stamp = Time.time;
            this.max_distance = this.speed * 400;
        }

        void Start()
        {        
            Invoke("destory_self", this.delay_destory_time);
        }

        void Update()
        {
            float distance = this.max_distance * Mathf.InverseLerp(this.time_stamp, this.time_stamp + this.delay_destory_time, Time.time)+ 15;
            this.transform.position = this.cam.transform.position + this.cam.transform.forward * distance;
            this.transform.forward = this.cam.transform.forward;


            float height = 2.0f * distance * Mathf.Tan(Camera.main.fieldOfView * 0.5f * Mathf.Deg2Rad);
            float width = height * this.cam.aspect;
            this.transform.localScale = new Vector3(width, height, 1);
        }

        private void destory_self()
        {
            Destroy(this.gameObject);
        }
    }
}
