using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;


namespace EasyGameStudio.scanner
{
    public class Create_scanner : MonoBehaviour
    {
        // [Header("Audio Source, Audio Clip")]
        // public AudioSource audio_source;
        // public AudioClip audio_clip_ka;

        [Header("prefab_sphere_scanner")]
        public GameObject prefab_sphere_scanner;

        [Header("prefab_double_sphere_scanner")]
        public GameObject prefab_double_sphere_scanner;

        [Header("prefab_cube_scanner")]
        public GameObject prefab_cube_scanner;

        [Header("prefab_double_cube_scanner")]
        public GameObject prefab_double_cube_scanner;

        [Header("prefab_camera_quad_scanner")]
        public GameObject prefab_camera_quad_scanner;

        //[Header("buttons")]
        //public Button[] btns;

        private GameObject prefab_scanner;
        [SerializeField] private int index;

        private int fingerID = -1;

        void Awake()
        {
#if !UNITY_EDITOR
                this.fingerID = 0; 
#endif
        }

        // Start is called before the first frame update
        void Start()
        {
            this.on_btn_click(0);
        }

        // Update is called once per frame
        void Update()
        {
            if (EventSystem.current.IsPointerOverGameObject(this.fingerID))
                return;

            if (Input.GetMouseButtonDown(0))
            {
                if (this.prefab_scanner == this.prefab_camera_quad_scanner)
                {
                    GameObject.Instantiate(this.prefab_scanner);
                }
                else
                {
                    Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                    RaycastHit hit;
                    if (Physics.Raycast(ray, out hit))
                    {
                        on_btn_click(index);
                        GameObject game_obj_scanner = Instantiate(this.prefab_scanner);
                        game_obj_scanner.transform.position = hit.point;

                        if (hit.collider.gameObject.name == "ground")
                        {
                            //Debug.Log(hit.transform.position);

                            
                        }
                    }
                }
            }
        }

        public void on_btn_click(int num)
        {
            //this.audio_source.PlayOneShot(this.audio_clip_ka);
            
            switch (num)
            {
                case 0:
                    this.prefab_scanner = this.prefab_sphere_scanner;
                    break;

                case 1:
                    this.prefab_scanner = this.prefab_double_sphere_scanner;
                    break;

                case 2:
                    this.prefab_scanner = this.prefab_cube_scanner;
                    break;

                case 3:
                    this.prefab_scanner = this.prefab_double_cube_scanner;
                    break;

                case 4:
                    this.prefab_scanner = this.prefab_camera_quad_scanner;
                    break;
            }


            // for (int i = 0; i < this.btns.Length; i++)
            // {
            //     this.btns[i].image.color = Color.white;
            // }
            //
            // this.btns[num].image.color = Color.red;
            
            return;
        }
    }
}
